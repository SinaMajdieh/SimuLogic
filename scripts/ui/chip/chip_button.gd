extends Button

## Signal emitted when a chip is added, passing the button's name.
signal add_chip(chip_name: String)

## Emits the `add_chip` signal when the button is pressed.
func _on_pressed() -> void:
	add_chip.emit(name)
