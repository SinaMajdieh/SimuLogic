class_name Chip
extends PanelContainer

# Preloaded scene for instantiating chips dynamically
static var chip_scene: PackedScene = preload("res://scenes/chip/chip.tscn")

# Blueprint defining the chip's structure and behavior
var schematic: ChipBlueprint

# Enumeration for different chip logic types
enum ChipType {AND, OR, NOT, COMPOSIT}

# Input and output pin arrays
@export var input_pins: Array[Pin]
@export var output_pins: Array[Pin]

# Chip name with a setter function that updates the UI
@export var chip_name: String:
	set(new_name):
		chip_name = new_name
		name_tag.text = new_name

# Chip type as defined by the enumeration
@export var chip_type: ChipType

# Node references for organizing inputs, outputs, and sub-chips
@onready var input_container: VBoxContainer = $Container/Inputs
@onready var output_container: VBoxContainer = $Container/Outputs
@onready var sub_chip_container: VBoxContainer = $Container/Chips
@onready var name_tag: Label = $Container/Chips/Name

# Retrieves an array of input states for processing logic
func get_input_array() -> Array[int]:
	var result: Array[int] = []
	for pin in input_pins:
		result.append(int(pin.state))
	return result

# Updates output state based on input states and chip logic type
func input_updated() -> void:
	var input: Array[int] = get_input_array()
	var output := false
	match chip_type:
		ChipType.AND:
			output = input.all(func(val): return val == 1)
		ChipType.OR:
			output = input.any(func(val): return val == 1)
		ChipType.NOT:
			output = not input[0]
		_:
			return
	output_pins[0].state = output

# Applies a background color to the chip’s stylebox
func set_bg_color(color: Color) -> void:
	var stylebox: StyleBoxFlat = get("theme_override_styles/panel").duplicate()
	stylebox.bg_color = color
	set("theme_override_styles/panel", stylebox)

# Initializes the chip with a description and sets up event connections
func init(description: ChipDescription) -> void:
	if description != null:
		set_bg_color(description.background_color)

	if chip_type != ChipType.COMPOSIT:
		for pin in input_pins:
			pin.pin_state_updated.connect(input_updated)
		input_updated()

# Creates and configures a pin based on the provided data
func build_pin(pin_data: PinData, render: bool) -> Pin:
	var pin: Pin = Pin.pin_scene.instantiate()
	pin.synthesize(pin_data)
	pin.parent_chip = self
	pin.visible = render
	return pin

# Establishes wiring connections between pins
func build_wiring(connections: Dictionary[String, Array]) -> void:
	for from_pin_path in connections:
		var from_pin: Pin = get_node(from_pin_path)
		if from_pin == null:
			continue
		for to_pin_path in connections[from_pin_path]:
			var to_pin: Pin = get_node(to_pin_path)
			if to_pin and to_pin not in from_pin.connected_to:
				from_pin.connect_to(to_pin)

# Constructs the chip from a blueprint and rendering level
func synthesize(blueprint: ChipBlueprint, render_level: int) -> void:
	schematic = blueprint
	chip_name = blueprint.name
	name = blueprint.name
	chip_type = blueprint.type
	#global_position = blueprint.position

	# Instantiate and configure sub-chips
	for sub_chip in blueprint.sub_chips:
		var sub_chip_node: Chip = chip_scene.instantiate()
		sub_chip_container.add_child(sub_chip_node)
		sub_chip_node.synthesize(sub_chip, render_level - 1)

	# Instantiate and configure input pins
	for pin_data in blueprint.input_pins:
		var pin: Pin = build_pin(pin_data, render_level >= 0)
		input_container.add_child(pin)
		input_pins.append(pin)

	# Instantiate and configure output pins
	for pin_data in blueprint.output_pins:
		var pin: Pin = build_pin(pin_data, render_level >= 0)
		output_container.add_child(pin)
		output_pins.append(pin)

	visible = render_level > 0
	init(blueprint.description)
	build_wiring(blueprint.connections)

# Handles UI hover effects
func _on_mouse_enter():
	modulate.a = 0.5

func _on_mouse_exit():
	modulate.a = 1

# Disconnects all wiring associated with the chip
func disconnect_chip() -> void:
	for pin in input_pins:
		pin.clear_connections()
	for pin in output_pins:
		pin.clear_connections()

func _on_renamed() -> void:
	chip_name = name
