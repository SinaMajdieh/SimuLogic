class_name WirePreview
extends Line2D

# ======================
# WIRE PREVIEW COMPONENT:
# ----------------------
# This class visualizes a wire preview before finalizing connections.
# It dynamically updates based on mouse movement and user interactions.
# ======================

# === PRELOADED WIRE PREVIEW SCENE ===
# Used for instantiating a temporary wire preview.
static var wire_preview_scene: PackedScene = preload("res://scenes/wire/wire_preview.tscn")

# === WIRE POINT STORAGE ===
# Tracks wire points dynamically for rendering purposes.
var points_list: Array[Vector2] = []

# === ACTIVE STATE TRACKING ===
# Determines whether the wire preview is currently active.
var is_active: bool = false

# === PIN REFERENCES ===
# Stores the source and target pins for wire connections.
var source_pin: Pin
var target_pin: Pin

# === NEXT JOINT POSITION ===
# Stores the next joint position during wire drawing.
var next_joint: Vector2

# ======================
# START WIRE PREVIEW
# ----------------------
# Initializes a wire preview from the selected source pin.
# ======================
func start_preview(pin: PinUI) -> void:
    if is_active:
        return
    source_pin = pin.logic
    points_list = [to_local(pin.get_center())]  # Start wire at pin's center
    is_active = true

# ======================
# UPDATE WIRE PREVIEW
# ----------------------
# Dynamically adjusts the wire preview based on mouse movement.
# ======================
func update_preview() -> void:
    if not is_active:
        return
    
    # Capture current mouse position
    next_joint = to_local(get_global_mouse_position())
    var last_point: Vector2 = points_list[-1]

    # Constrain movement to the axis with the greater difference for smoother alignment
    if abs(next_joint.x - last_point.x) > abs(next_joint.y - last_point.y):
        next_joint.y = last_point.y  # Maintain horizontal alignment
    else:
        next_joint.x = last_point.x  # Maintain vertical alignment

    # Update the preview points
    points = points_list + [next_joint]

# ======================
# ADD JOINT TO WIRE PREVIEW
# ----------------------
# Appends a joint position to the wire preview for segmenting.
# ======================
func add_joint(joint_position: Vector2) -> void:
    points_list.append(joint_position)

# ======================
# FINALIZE WIRE CONNECTION
# ----------------------
# Completes the wire connection by snapping to the target pin's position.
# ======================
func finalize_connection(pin: PinUI) -> void:
    if not is_active:
        return
    
    # Align the last wire point with the target pin's center
    points_list[-1] = to_local(pin.get_center())
    is_active = false
    target_pin = pin.logic

    # Instantiate the final wire and apply constraints
    var wire: Wire = Wire.new_wire(source_pin, target_pin, points_list)
    wire.constrain_line()

    # Notify the system to add the wire
    WorkBenchComm.add_wire(wire)

    # Cleanup the preview instance
    points = []
    is_active = false

# ======================
# CONTINUOUSLY UPDATE WIRE PREVIEW
# ----------------------
# Ensures dynamic wire preview updates while active.
# ======================
func _process(_delta: float) -> void:
    update_preview()

# ======================
# CANCEL WIRE PREVIEW
# ----------------------
# Removes the wire preview and resets its state.
# ======================
func cancel() -> void:
    points = []
    is_active = false

# ======================
# INITIALIZE WIRE PREVIEW
# ----------------------
# Sets this instance as the active wire preview manager.
# ======================
func _ready() -> void:
    Comm.wire_preview = self
