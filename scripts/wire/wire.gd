class_name Wire
extends Line2D

# ======================
# WIRE MANAGEMENT SYSTEM:
# ----------------------
# This class represents a wire connecting pins in the workbench.
# It handles interactions, state changes, collision detection, and serialization.
# ======================

# === CLICK DETECTION THRESHOLD ===
# Defines the minimum distance for detecting wire clicks.
const CLICK_DISTANCE_THRESHOLD: float = 10

# === WIRE COLOR CONFIGURATION ===
# Stores state and inactive colors for wire visualization.
@export var active_color: Color = Color("#FF5555")
@export var inactive_color: Color = Color("#0D0D0D")

# === PRELOADED WIRE SCENE ===
# Defines the base wire scene used for instantiation.
static var wire_scene: PackedScene = preload("res://scenes/wire/wire.tscn")

# === COLLISION DETECTION COMPONENT ===
# Enables wire interaction detection.
@export var area: Area2D

# === PIN CONNECTION TRACKING ===
# Stores the connected pins at both ends of the wire.
var source_pin: Pin = null
var target_pin: Pin = null

# === LAYER INDEX TRACKING ===
# Determines wire rendering priority.
var layer_index: int = 0

@onready var base_line: float = width

# ======================
# ACTIVE STATE MANAGEMENT
# ----------------------
# Tracks wire state changes and updates visuals accordingly.
# ======================
var state: LogicUtils.State = LogicUtils.State.Z:
	set(new_state):
		state = new_state
		update_gui()

# ======================
# UPDATE WIRE VISUALS
# ----------------------
# Adjusts wire color based on its state state.
# ======================
func update_gui() -> void:
	match state:
		LogicUtils.State.HIGH:
			default_color = ColorMan.get_glowing_color(source_pin.ui.pin_color)
		LogicUtils.State.LOW:
			default_color = ColorMan.get_muted_color(source_pin.ui.pin_color)
		LogicUtils.State.Z:
			default_color = Color.BLACK

# ======================
# CHANGE WIRE STATE
# ----------------------
# Updates wire state and refreshes visuals.
# ======================
func change_state(new_state: LogicUtils.State) -> void:
	state = new_state

# ======================
# HANDLE SOURCE PIN STATE UPDATE
# ----------------------
# Adjusts wire state based on the connected source pin.
# ======================
func source_pin_updated() -> void:
	if source_pin:
		change_state(source_pin.state)

# ======================
# INITIALIZE WIRE COMPONENT
# ----------------------
# Sets up the wire and connects signals upon startup.
# ======================
func _ready() -> void:
	if source_pin:
		source_pin.pin_state_updated.connect(source_pin_updated)
		source_pin_updated()
	
	# Generate collision shapes for wire interaction
	update_collision_shape()

# ======================
# CONTINUOUSLY UPDATE WIRE POSITION
# ----------------------
# Removes wire if either of its connected pins are missing.
# ======================
func _process(_delta: float) -> void:
	if not source_pin or not target_pin:
		WorkBenchComm.remove_wire(self)
		return
	keep_ends()

# ======================
# MAINTAIN WIRE ENDPOINT ALIGNMENT:
# ----------------------
# This function ensures that the wire remains properly attached
# to its source and target pins while adjusting intermediate points.
# It updates collision shapes if necessary.
# ======================

func keep_ends() -> void:
	# Retrieve the latest positions of the source and target pins
	var new_start: Vector2 = to_local(source_pin.ui.get_center())
	var new_end: Vector2 = to_local(target_pin.ui.get_center())

	var shape_changed: bool = false  # Tracks whether shape adjustments were made

	# Adjust the first segment if the start position has changed
	if points[0] != new_start:
		if points.size() > 2:
			points[1] = adjust_point(points[1], new_start)
		shape_changed = true

	# Adjust the last segment if the end position has changed
	if points[-1] != new_end:
		if points.size() > 2:
			points[-2] = adjust_point(points[-2], new_end)
		shape_changed = true

	# If changes were made, update endpoints and collision shape
	if shape_changed:
		points[0] = new_start
		points[-1] = new_end
		update_collision_shape()

# ======================
# CREATE A NEW WIRE INSTANCE
# ----------------------
# Instantiates a wire with the specified connection points.
# ======================
static func new_wire(wire_source_pin: Pin, wire_target_pin: Pin, wire_points: Array[Vector2]) -> Wire:
	var wire: Wire = wire_scene.instantiate()
	wire.source_pin = wire_source_pin
	wire.target_pin = wire_target_pin
	wire.points = wire_points
	return wire

# ======================
# POINT ALIGNMENT FUNCTION:
# ----------------------
# This function adjusts a given point to align with a reference point.
# It ensures movement follows the axis with the greatest difference.
# ======================

func adjust_point(point: Vector2, reference: Vector2) -> Vector2:
	# Compute the difference between the point and reference along both axes
	var diff_x: float = abs(reference.x - point.x)
	var diff_y: float = abs(reference.y - point.y)

	# Align the point based on the larger axis difference
	if diff_x > diff_y:
		return Vector2(point.x, reference.y)  # Maintain X, adjust Y
	return Vector2(reference.x, point.y)  # Maintain Y, adjust X

# ======================
# CONSTRAIN WIRE ALIGNMENT
# ----------------------
# Ensures proper alignment of wire points for a clean visual appearance.
# ======================
func constrain_line() -> void:
	if points.size() < 3:
		return

	var constrained_points: PackedVector2Array = points.duplicate()

	for i in range(constrained_points.size() - 2, 0, -1):
		var prev: Vector2 = constrained_points[i + 1]
		var current: Vector2 = constrained_points[i]

		if abs(current.x - prev.x) > abs(current.y - prev.y):
			current.y = prev.y
		else:
			current.x = prev.x

		constrained_points[i] = current

	var first: Vector2 = constrained_points[0]
	var second: Vector2 = constrained_points[1]
	var adjustment_point := second

	if abs(first.x - second.x) > abs(first.y - second.y):
		adjustment_point.y = first.y
	else:
		adjustment_point.x = first.x

	#constrained_points.insert(1, adjustment_point)
	points = constrained_points

# ======================
# UPDATE COLLISION SHAPES
# ----------------------
# Generates interaction detection areas along wire segments.
# ======================
func update_collision_shape() -> void:
	for child in area.get_children():
		child.queue_free()

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

# ======================
# HANDLE MOUSE HOVER EFFECTS
# ----------------------
# Adjusts wire transparency when hovered.
# ======================
func _on_mouse_entered() -> void:
	modulate.a = 0.5

func _on_mouse_exited() -> void:
	modulate.a = 1

# ======================
# FIND CLOSEST WIRE SEGMENT
# ----------------------
# Identifies the nearest wire segment to a given point.
# ======================
func get_closest_point_to(point: Vector2) -> Vector2:
	var closest_point_global: Vector2 = points[-1]

	for i in range(points.size() - 1):
		var start = points[i]
		var end = points[i + 1]

		var closest_point = Geometry2D.get_closest_point_to_segment(point, start, end)
		if closest_point.distance_squared_to(point) < closest_point_global.distance_squared_to(point):
			closest_point_global = closest_point
	
	return closest_point_global

# ======================
# DETECT MOUSE COLLISION WITH WIRE
# ----------------------
# Checks if the mouse cursor intersects with the wire.
# ======================
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

# ======================
# HANDLE WIRE INTERACTIONS
# ----------------------
# Detects clicks and triggers wire-related actions.
# ======================
func _input(event) -> void:
	if event is InputEventMouseMotion:
		if mouse_collides_with_line():
			_on_mouse_entered()
		else:
			_on_mouse_exited()
	elif Input.is_action_just_pressed("ui_left_click") and mouse_collides_with_line():
		InputBus.notify_wire_clicked(self, get_closest_point_to(to_local(get_global_mouse_position())))

# ======================
# SERIALIZE WIRE DATA
# ----------------------
# Extracts wire attributes for saving or exporting.
# ======================
func get_wire_data() -> WireData:
	var wire_data: WireData = WireData.new()
	wire_data.source_pin = Sim.get_path_to(source_pin)
	wire_data.target_pin = Sim.get_path_to(target_pin)
	wire_data.points = points
	return wire_data
