extends Node

# ======================
# ITEM DRAGGING HANDLER:
# ----------------------
# This class manages dragging interactions for UI elements (chips, pins).
# It tracks the selected item and ensures smooth movement using grid snapping.
# ======================

# === DRAGGING STATE VARIABLES ===
# Stores the currently dragged UI item and its offset from the cursor position.
var dragged_item: Control = null
var drag_offset: Vector2 = Vector2.ZERO

# ======================
# HANDLE ITEM DRAGGING
# ----------------------
# Processes input events, updating item positions and stopping dragging when released.
# Supports optional grid snapping when the shift key is held.
# ======================
func process_drag(event: InputEvent) -> void:
    if not dragged_item:
        return

    # Stop dragging when the left mouse button is released
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if not event.pressed:
            dragged_item = null

    # Update the dragged item's position based on mouse movement
    elif event is InputEventMouseMotion:
        var absolute_position: Vector2 = event.position - drag_offset
        
        # Apply grid snapping if the shift key is held
        if Input.is_action_pressed("left_shift"):
            dragged_item.global_position = snap_to_grid(absolute_position)
        else:
            dragged_item.global_position = absolute_position

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
    drag_offset = clicked_position - item.global_position  # Store the offset for precise movement

# ======================
# CONNECT INPUT EVENTS
# ----------------------
# Attaches item click events to initiate dragging interactions.
# ======================
func _ready() -> void:
    InputBus.chip_clicked.connect(_on_item_clicked)
    InputBus.pin_body_clicked.connect(_on_item_clicked)
