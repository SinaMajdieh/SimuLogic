class_name InteractableBusUI
extends Control

var logic: Bus

static var interactable_bus_ui_scene: PackedScene = preload("res://scenes/bus/interactable_bus_ui.tscn")

@export var grid_container: GridContainer
@export var item: AspectRatioContainer

@export var rows: int = 2
@export var columns: int = 2
@export var pins_minimum_size = Vector2(10, 10)

@export var color: Color

var buttons: Array[ColorRect] = []

func _ready() -> void:
	grid_container.columns = columns
	for i: int in range(rows * columns):
		var new_item: AspectRatioContainer = item.duplicate()
		var new_button: ColorRect = new_item.get_node("ColorRect")
		new_item.show()
		buttons.append(new_button)
		new_button.state_changed.connect(_on_button_pressed)
		new_button.index = i
		new_button.groupe_color = color
		new_button.custom_minimum_size = pins_minimum_size

		grid_container.add_child(new_item)

func update_gui() -> void:
	if not logic:
		return
	var states: Array[LogicUtils.State] = logic.get_state()
	if states.size() != buttons.size():
		Logger.log_with_time(Logger.Logs.ERRORS, "Bus Pin mismatch", true)
		return
	for i: int in range(states.size()):
		buttons[i].state = states[i]

static func build_ui(bus: Bus) -> InteractableBusUI:
	var ui: InteractableBusUI = interactable_bus_ui_scene.instantiate()
	ui.logic = bus
	return ui

func get_button_states() -> Array[LogicUtils.State]:
	var states: Array[LogicUtils.State] = []
	for button: ColorRect in buttons:
		states.append(button.state)
	return states

func _on_button_pressed(_index: int) -> void:
	if not logic:
		return
	logic.set_state(get_button_states())
