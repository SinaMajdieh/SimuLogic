extends Node

## Stores the currently dragged chip and offset position.
var dragged_chip: Chip = null
var drag_offset: Vector2 = Vector2.ZERO

## Handles mouse events for chip dragging.
func process_drag(event: InputEvent) -> void:
	if not dragged_chip:
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed:
			dragged_chip = null

	elif event is InputEventMouseMotion:
		dragged_chip.global_position = event.position - drag_offset

## Called when a chip is clicked to initiate dragging.
func _on_chip_clicked(chip: Chip, clicked_position: Vector2) -> void:
	if not get_parent().is_active:
		return

	dragged_chip = chip
	drag_offset = clicked_position - chip.global_position

## Connects the chip click event at initialization.
func _ready() -> void:
	InputBus.chip_clicked.connect(_on_chip_clicked)
