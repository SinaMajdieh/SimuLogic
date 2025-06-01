class_name WirePreview
extends Line2D

# Preloaded scene for wire preview visualization
static var wire_preview_scene: PackedScene = preload("res://scenes/wire/wire_preview.tscn")

# Stores wire points dynamically for rendering
var points_list: Array[Vector2] = []

# Tracks whether the preview is currently active
var is_active: bool = false

# References the source and target pins for the wire connection
var source_pin: Pin
var target_pin: Pin

# Stores the next joint position during wire drawing
var next_joint: Vector2

# Initializes the wire preview from the selected pin
func start_preview(pin: Pin) -> void:
    source_pin = pin
    points_list = [pin.get_center()]  # Start the wire at the pin's center position
    is_active = true

# Updates the wire preview dynamically based on mouse movement
func update_preview() -> void:
    if not is_active:
        return
    
    # Capture the current mouse position
    next_joint = get_global_mouse_position()
    var last_point: Vector2 = points_list[-1]

    # Constrain movement to the axis with the greater difference for smoother alignment
    if abs(next_joint.x - last_point.x) > abs(next_joint.y - last_point.y):
        next_joint.y = last_point.y  # Maintain horizontal alignment
    else:
        next_joint.x = last_point.x  # Maintain vertical alignment

    # Update the preview points
    points = points_list + [next_joint]

# Adds a joint position to the wire preview
func add_joint(joint_position: Vector2) -> void:
    points_list.append(joint_position)

# Finalizes the wire connection by snapping to the target pin's position
func finalize_connection(pin: Pin) -> void:
    if not is_active:
        return
    
    # Set the last wire point to align with the target pin's center
    points_list[-1] = pin.get_center()
    is_active = false
    target_pin = pin

    # Instantiate the final wire and apply constraints
    var wire: Wire = Wire.new_wire(source_pin, target_pin, points_list)
    wire.constrain_line()
    
    # Notify the system to add the wire
    WorkBenchComm.add_wire(wire)

    # Cleanup the preview instance
    queue_free()

# Continuously updates wire preview while active
func _process(_delta: float) -> void:
    update_preview()

# Cancels the wire preview and removes the temporary visualization
func cancel() -> void:
    queue_free()
