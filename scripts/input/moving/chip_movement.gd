extends Node

# ======================
# ITEM DRAGGING HANDLER:
# ----------------------
# This class manages dragging interactions for UI elements (chips, pins).
# It tracks the selected item and ensures smooth movement using axis locking and grid snapping.
# ======================

# === DRAGGING STATE VARIABLES ===
# Stores the currently dragged UI item and its offset from the cursor position.
var dragged_item: Control = null
var drag_offset: Vector2 = Vector2.ZERO
var start_position: Vector2

# === AXIS LOCKING CONFIGURATION ===
# Helps constrain movement along a dominant axis during dragging.
enum Axis {X, Y, NONE}
const AXIS_LOCK_THRESHOLD: float = 4
var locked_axis: Axis = Axis.NONE

# ======================
# HANDLE ITEM DRAGGING
# ----------------------
# Processes input events, updating item positions and stopping dragging when released.
# Supports axis locking and optional grid snapping when the shift key is held.
# ======================
func process_drag(event: InputEvent) -> void:
    if not dragged_item:
        return

    # Stop dragging when the left mouse button is released
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if not event.pressed:
            dragged_item = null
            locked_axis = Axis.NONE

    # Update the dragged item's position based on mouse movement
    elif event is InputEventMouseMotion:
        var absolute_position: Vector2 = event.global_position - drag_offset
        var new_position: Vector2 = absolute_position

        # Apply axis constraint if shift is held
        if Input.is_action_pressed("left_shift"):
            new_position = constrain_position(start_position, absolute_position)

        # Apply grid snapping if enabled
        if WorkBenchComm.snap_to_grid:
            new_position = snap_to_grid(new_position)

        # Update item position
        dragged_item.global_position = new_position

# ======================
# CONSTRAIN MOVEMENT ALONG DOMINANT AXIS
# ----------------------
# Locks movement to the axis with the greatest displacement when shift is held.
# ======================
func constrain_position(position: Vector2, mouse_position: Vector2) -> Vector2:
    var delta: Vector2 = mouse_position - position
    var new_position: Vector2 = mouse_position

    # Lock axis movement if displacement exceeds the threshold
    if locked_axis == Axis.NONE and delta.length() > AXIS_LOCK_THRESHOLD:
        locked_axis = Axis.X if abs(delta.x) > abs(delta.y) else Axis.Y

    # Maintain locked axis alignment
    elif locked_axis != Axis.NONE:
        if locked_axis == Axis.X:
            new_position.y = position.y
        else:
            new_position.x = position.x

    return new_position

# ======================
# SNAP POSITION TO GRID
# ----------------------
# Adjusts a position to align with the workbench grid spacing.
# Used to ensure consistent placement of dragged UI elements.
# ======================
func snap_to_grid(position: Vector2) -> Vector2:
    return Vector2(
        round(position.x / WorkBenchComm.grid_spacing) * WorkBenchComm.grid_spacing,
        round(position.y / WorkBenchComm.grid_spacing) * WorkBenchComm.grid_spacing
    )

# ======================
# INITIALIZE ITEM DRAGGING
# ----------------------
# Called when an item is clicked, storing the reference for smooth dragging.
# ======================
func _on_item_clicked(item: Control, clicked_position: Vector2) -> void:
    if not get_parent().is_active:
        return

    dragged_item = item
    start_position = item.global_position
    drag_offset = clicked_position - item.global_position  # Store the offset for precise movement

# ======================
# CONNECT INPUT EVENTS
# ----------------------
# Attaches item click events to initiate dragging interactions.
# ======================
func _ready() -> void:
    InputBus.chip_clicked.connect(_on_item_clicked)
    InputBus.pin_body_clicked.connect(_on_item_clicked)
