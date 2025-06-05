class_name PinUI
extends MarginContainer

# ======================
# PIN UI COMPONENT:
# ----------------------
# This class represents a UI element for a pin, visually linked to its logic counterpart.
# It manages appearance updates, interactions, and tooltip adjustments.
# ======================

# === LOGIC PIN REFERENCE ===
# Stores a reference to the logic component associated with the pin.
var logic: Pin

# === PRELOADED PIN UI SCENE ===
# Used for instantiating new pin UI elements dynamically.
static var pin_ui_scene: PackedScene = preload("res://scenes/pin/pin_ui.tscn")

# === UI ELEMENT REFERENCES ===
# Contains references to associated UI components.
@export var input_manager: Node
@export var button_gui: CheckButton

# ======================
# PIN COLOR MANAGEMENT
# ----------------------
# Sets the pin color and updates its UI appearance accordingly.
# ======================
@export var pin_color: Color:
	set(value):
		pin_color = value
		update_button_gui()

# ======================
# UPDATE TOOLTIP ON RENAME
# ----------------------
# Modifies the tooltip text when the pin name changes.
# ======================
func _on_renamed() -> void:
	button_gui.tooltip_text = name

# ======================
# INITIALIZE PIN UI
# ----------------------
# Sets initial properties and updates the visual state.
# ======================
func _ready() -> void:
	update_button_gui()
	button_gui.tooltip_text = name

# ======================
# UPDATE PIN APPEARANCE
# ----------------------
# Adjusts the visual state based on logic values.
# ======================
func update_button_gui() -> void:
	if not button_gui:
		return
	
	if not logic:
		button_gui.button_pressed = false
		button_gui.modulate = ColorMan.get_muted_color(pin_color)
	else:
		button_gui.button_pressed = logic.state
		button_gui.modulate = ColorMan.get_glowing_color(pin_color) if logic.state else ColorMan.get_muted_color(pin_color)

# ======================
# GET PIN CENTER POSITION
# ----------------------
# Returns the center position of the pin for alignment and interactions.
# ======================
func get_center() -> Vector2:
	var global_scale: Vector2 = get_global_transform().get_scale()
	return (global_position + (size * global_scale / 2))

# ======================
# HANDLE PIN CLICK INTERACTION
# ----------------------
# Toggles the pin state when clicked and notifies the input bus.
# ======================
func _on_pressed() -> void:
	button_gui.button_pressed = not button_gui.button_pressed
	InputBus.notify_pin_clicked(self)

# ======================
# CREATE PIN UI INSTANCE
# ----------------------
# Instantiates and initializes a UI component for a given logic pin.
# ======================
static func build_ui(pin: Pin) -> PinUI:
	var ui: PinUI = pin_ui_scene.instantiate()
	ui.logic = pin
	ui.name = pin.name
	return ui

# ======================
# CLEANUP PIN LOGIC ON REMOVAL
# ----------------------
# Ensures the logic component is safely removed when the UI is deleted.
# ======================
func _on_tree_exited() -> void:
	if logic and logic.get_parent():
		logic.get_parent().remove_child(logic)
	logic.queue_free()
