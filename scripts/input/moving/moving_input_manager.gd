class_name MovingMode
extends InputMode

@onready var chip_movement: Node = $Chip  ## Reference to chip movement handler

## Processes input events by forwarding them to the chip movement logic.
func _input(event: InputEvent) -> void:
	chip_movement.process_drag(event)

## Activates the moving mode.
func activate() -> void:
	is_active = true

## Deactivates moving mode and clears dragging state.
func deactivate() -> void:
	chip_movement.dragged_chip = null
	is_active = false
