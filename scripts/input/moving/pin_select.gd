extends Node

## Handles pin clicks, toggling state for valid input pins.
func _on_pin_clicked(pin: Pin) -> void:
	if not pin is InteractablePin:
		return 
	if not get_parent().is_active or pin.pin_type == Pin.PinType.OUTPUT:
		return
	pin.state = not pin.state

## Connects pin click event upon initialization.
func _ready() -> void:
	InputBus.pin_clicked.connect(_on_pin_clicked)
