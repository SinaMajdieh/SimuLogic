extends InteractablePin

@export var label: LineEdit  # Displays the pin’s name
@export var button: CheckButton  # Used for interaction positioning

func _ready() -> void:
	label.text = name

	# Set layout direction based on pin type
	match pin_type:
		Pin.PinType.INPUT:
			layout_direction = Control.LAYOUT_DIRECTION_LTR  # Input: left-to-right
		Pin.PinType.OUTPUT:
			layout_direction = Control.LAYOUT_DIRECTION_RTL  # Output: right-to-left

func _on_line_edit_text_changed(new_text: String) -> void:
	# Avoid setting an empty name
	if new_text.is_empty():
		return
	name = new_text

func get_center() -> Vector2:
	# Returns the center position of the button for alignment
	return button.global_position + button.size / 2
