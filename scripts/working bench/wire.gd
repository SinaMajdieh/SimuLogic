class_name Wire
extends Line2D

# Distance threshold for detecting wire clicks
const CLICK_DISTANCE_THRESHOLD: float = 10

# Colors for active/inactive wire states
@export var active_color: Color = Color("#FF5555")
@export var inactive_color: Color = Color("#0D0D0D")

# Preloaded scene for wire instantiation
static var wire_scene: PackedScene = preload("res://scenes/wire/wire.tscn")

# Collision detection area for wire interaction
@export var area: Area2D

# Stores the connected pins
var source_pin: Pin = null
var target_pin: Pin = null

# Tracks active state, updating visuals accordingly
var active: bool = false:
    set(new_state):
        active = new_state
        update_gui()

# Updates the wire's color based on its active state
func update_gui() -> void:
    default_color = active_color if active else inactive_color

# Changes wire state and updates visuals
func change_state(new_state: bool) -> void:
    active = new_state

# Updates wire state based on the source pin's state
func source_pin_updated() -> void:
    if source_pin:
        change_state(source_pin.state)

# Connects the pin state update signal and applies the initial state
func _ready() -> void:
    if source_pin:
        source_pin.pin_state_updated.connect(source_pin_updated)
        source_pin_updated()
    
    # Generate collision shapes for wire interaction
    update_collision_shape()

# Continuously updates wire position dynamically
func _process(_delta: float) -> void:
    # Remove wire if source or target pin is missing
    if not source_pin or not target_pin:
        WorkBenchComm.remove_wire(self)
        return
    
    var new_start_position: Vector2 = source_pin.get_center()
    var new_end_position: Vector2 = target_pin.get_center()

    # Adjust wire position only if the start or end points have changed
    if points[0] != new_start_position or points[-1] != new_end_position:
        var offset: Vector2 = new_start_position - points[0]
        for i in range(len(points)):
            points[i] += offset
        
        points[-1] = target_pin.get_center()
        update_collision_shape()

# Creates a new wire instance with specified pins and points
static func new_wire(wire_source_pin: Pin, wire_target_pin: Pin, wire_points: Array[Vector2]) -> Wire:
    var wire: Wire = wire_scene.instantiate()
    wire.source_pin = wire_source_pin
    wire.target_pin = wire_target_pin
    wire.points = wire_points
    return wire

# Constrains wire points to maintain proper alignment
func constrain_line() -> void:
    if points.size() < 3:
        return

    var constrained_points: PackedVector2Array = points.duplicate()

    # Adjust wire segments for alignment
    for i in range(constrained_points.size() - 2, 0, -1):
        var prev: Vector2 = constrained_points[i + 1]
        var current: Vector2 = constrained_points[i]

        if abs(current.x - prev.x) > abs(current.y - prev.y):
            current.y = prev.y
        else:
            current.x = prev.x

        constrained_points[i] = current

    # Ensure smooth connection between first two points
    var first: Vector2 = constrained_points[0]
    var second: Vector2 = constrained_points[1]
    var adjustment_point := second

    if abs(first.x - second.x) > abs(first.y - second.y):
        adjustment_point.y = first.y
    else:
        adjustment_point.x = first.x

    constrained_points.insert(1, adjustment_point)
    points = constrained_points

# Updates collision shapes for wire interaction detection
func update_collision_shape() -> void:
    # Remove old collision shapes
    for child in area.get_children():
        child.queue_free()

    # Create new collision shapes along wire segments
    for i in range(points.size() - 1):
        var a: Vector2 = points[i]
        var b: Vector2 = points[i + 1]
        var shape: RectangleShape2D = RectangleShape2D.new()
        var segment_vector: Vector2 = b - a
        var length: float = segment_vector.length()
        shape.extents = Vector2(length / 2.0, CLICK_DISTANCE_THRESHOLD / 2.0)

        var shape_node: CollisionShape2D = CollisionShape2D.new()
        shape_node.shape = shape

        var center: Vector2 = (a + b) / 2
        shape_node.position = center
        shape_node.rotation = segment_vector.angle()

        area.add_child(shape_node)

# Handles mouse hover effects
func _on_mouse_entered() -> void:
    modulate.a = 0.5

func _on_mouse_exited() -> void:
    modulate.a = 1

# Finds the closest wire segment to a given point
func get_closest_point_to(point: Vector2) -> Vector2:
    var closest_point_global: Vector2 = points[-1]

    for i in range(points.size() - 1):
        var start = points[i]
        var end = points[i + 1]

        # Determine closest point on the segment
        var closest_point = Geometry2D.get_closest_point_to_segment(point, start, end)

        # Check if it's the closest known point
        if closest_point.distance_squared_to(point) < closest_point_global.distance_squared_to(point):
            closest_point_global = closest_point
    
    return closest_point_global

# Checks if the mouse is colliding with the wire
func mouse_collides_with_line() -> bool:
    var mouse_pos = get_global_mouse_position()

    var query = PhysicsPointQueryParameters2D.new()
    query.position = mouse_pos
    query.collide_with_areas = true
    query.collide_with_bodies = false

    var space = get_world_2d().direct_space_state
    var result = space.intersect_point(query)

    for hit in result:
        if hit.collider == area:
            return true
    
    return false

# Handles input events for wire interaction
func _input(event) -> void:
    if event is InputEventMouseMotion:
        if mouse_collides_with_line():
            _on_mouse_entered()
        else:
            _on_mouse_exited()
    elif Input.is_action_just_pressed("ui_left_click") and mouse_collides_with_line():
        InputBus.notify_wire_clicked(self, get_closest_point_to(get_global_mouse_position()))

# Extracts wire data for serialization
func get_wire_data() -> WireData:
    var wire_data: WireData = WireData.new()
    wire_data.source_pin = WorkBenchComm.work_bench.get_path_to(source_pin)
    wire_data.target_pin = WorkBenchComm.work_bench.get_path_to(target_pin)
    wire_data.points = normalize_wire_points(points, WorkBenchComm.work_bench.get_rect().size)
    return wire_data

# Normalizes wire points relative to a reference size
static func normalize_wire_points(wire_points: PackedVector2Array, reference_size: Vector2) -> PackedVector2Array:
    var normalized: PackedVector2Array = PackedVector2Array()
    for point in wire_points:
        normalized.append(point / reference_size)
    return normalized

# Denormalizes wire points relative to a reference size
static func denormalize_wire_points(wire_points: PackedVector2Array, reference_size: Vector2) -> PackedVector2Array:
    var denormalized: PackedVector2Array = PackedVector2Array()
    for point in wire_points:
        denormalized.append(point * reference_size)
    return denormalized