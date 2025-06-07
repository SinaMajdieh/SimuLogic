class_name InteractablePin
extends PinUI

# ======================
# INTERACTABLE PIN UI:
# ----------------------
# This class extends the standard Pin UI with interactive features.
# It supports renaming, layout adjustments, and click detection.
# ======================

# === UI ELEMENT REFERENCES ===
# Stores key UI components for interaction.
@export var label: LineEdit  # Displays the pin’s name
@export var button: CheckButton  # Handles user interaction and positioning

# ======================
# INITIALIZE PIN UI
# ----------------------
# Sets up pin properties, updates UI, and configures layout based on pin type.
# ======================
func _ready() -> void:
	if logic:
		name = logic.name

	update_button_gui()

	label.text = name

	# Adjust layout direction according to pin type
	if logic:
		match logic.pin_type:
			Pin.PinType.INPUT:
				layout_direction = Control.LAYOUT_DIRECTION_LTR  # Input: left-to-right
			Pin.PinType.OUTPUT:
				layout_direction = Control.LAYOUT_DIRECTION_RTL  # Output: right-to-left

# ======================
# HANDLE PIN NAME EDITING
# ----------------------
# Updates the pin's name when modified in the text field.
# Prevents empty names from being assigned.
# ======================
func _on_line_edit_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		return
	new_text = new_text.to_upper()
	label.text = new_text
	label.caret_column = len(new_text)
	name = new_text
	if logic:
		logic.name = new_text

# ======================
# GET PIN CENTER POSITION
# ----------------------
# Calculates and returns the center position of the button for alignment.
# ======================
func get_center() -> Vector2:
	var global_scale: Vector2 = button.get_global_transform().get_scale()
	return button.global_position + (button.size * global_scale / 2)

# ======================
# HANDLE TEXT FIELD INPUT
# ----------------------
# Releases focus on the label when pressing cancel.
# ======================
func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		label.release_focus()

# ======================
# CREATE PIN UI INSTANCE
# ----------------------
# Instantiates and initializes an interactable UI for the given logic pin.
# ======================
static func build_ui(pin: Pin) -> InteractablePin:
	var ui: InteractablePin = Pin.interactable_pin_logic_scene.instantiate()
	ui.logic = pin
	ui.name = pin.name
	return ui
