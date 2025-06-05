class_name Chip
extends Node

# ======================
# CHIP CLASS OVERVIEW:
# ----------------------
# This class represents a logic chip in the simulator. It maintains input/output pins,
# handles processing logic (e.g., AND, NOT gates), and manages UI separation.
# It also supports composite chips, which contain multiple sub-chips and complex wiring setups.
# ======================

# === PRELOADED CHIP SCENES ===
# These scenes are used to dynamically instantiate chips based on their logic type.
static var chip_logic_scene: PackedScene = preload("res://scenes/chip/chip_logic.tscn")
static var seven_segment_logic_scene: PackedScene = preload("res://scenes/chip/seven_segment/seven_segment_logic.tscn")

# === CHIP PROPERTIES ===
@export var chip_name: String  # The name assigned to this chip instance.

# Blueprint defining the chip's internal structure (pins, sub-chips, wiring)
var schematic: ChipBlueprint

# UI reference (kept separate from logic; only instantiated if needed)
var ui: ChipUI  

# Enumeration defining different chip types for logic processing
enum ChipType {AND, NOT, SEVENSEGMENT, COMPOSIT}

# Stores all input and output pins attached to the chip
@export var input_pins: Array[Pin]
@export var output_pins: Array[Pin]

# Defines the type of logic this chip implements
@export var chip_type: ChipType

# Node references used to organize UI pin containers and sub-chips
@export var input_container: Node
@export var output_container: Node
@export var sub_chip_container: Node

# ======================
# RETRIEVE INPUT STATES
# ----------------------
# This function extracts the boolean states of all input pins for use in logic operations.
# It returns an array of true/false values corresponding to the pin states.
# ======================
func get_input_array() -> Array[bool]:
	var result: Array[bool] = []
	for pin in input_pins:
		result.append(pin.state)  # Append each pin's state to the result array.
	return result

# ======================
# PROCESS CHIP LOGIC
# ----------------------
# This function executes the logic operation based on the chip type.
# If the chip is NOT or AND, it applies the appropriate gate function.
# If it is another type (like SevenSegment), it skips logic handling.
# ======================
func input_updated() -> void:
	var input: Array[bool] = get_input_array()
	var output := false  # Default output state
	
	# Apply logic based on chip type
	match chip_type:
		ChipType.AND:
			output = input.all(func(val): return val)  # AND gate: true if all inputs are true
		ChipType.NOT:
			output = not input[0]  # NOT gate: invert the first input
		_:
			return  # Skip unsupported logic types
		
	# Apply artificial processing delay (simulating hardware gate delay)
	await apply_gate_delay()

	# Set the output pin's state based on the computed logic
	output_pins[0].state = output

# ======================
# SIMULATE PROCESSING DELAY
# ----------------------
# This function introduces a delay before updating the output state.
# It simulates the time hardware gates take to process signals.
# ======================
func apply_gate_delay() -> void:
	if Comm.gate_delay == 0:
		return  # Skip delay if the gate delay setting is disabled.
	$PreciseTimer.start_timer(Comm.gate_delay)
	await $PreciseTimer.time_out  # Wait for the timer to expire before continuing.

# ======================
# INITIALIZE CHIP LOGIC
# ----------------------
# When the chip is first created, this function sets up its input pins.
# If the chip is NOT composite, it connects input pin signals to the update function.
# ======================
func init() -> void:
	if chip_type != ChipType.COMPOSIT:
		for pin in input_pins:
			pin.pin_state_updated.connect(input_updated)  # Attach input change events to processing function.
		input_updated()  # Execute first-time logic evaluation.

# ======================
# BUILD A PIN INSTANCE
# ----------------------
# This function creates a pin node based on provided blueprint data.
# The _render parameter is used to control whether UI should be generated.
# ======================
func build_pin(pin_data: PinData, _render: bool) -> Pin:
	var pin: Pin = Pin.pin_logic_scene.instantiate()
	pin.synthesize(pin_data)  # Apply blueprint data to configure the pin.
	pin.parent_chip = self  # Assign chip ownership.
	return pin

# ======================
# CONNECT WIRES BETWEEN PINS
# ----------------------
# This function establishes connections between pins based on blueprint wiring data.
# It iterates through the connection dictionary and links corresponding pins.
# ======================
func build_wiring(connections: Dictionary[String, Array]) -> void:
	for from_pin_path in connections:
		var from_pin: Pin = get_node(from_pin_path)  # Retrieve source pin.
		if from_pin == null:
			continue
		
		# Loop through target pin paths and establish connections
		for to_pin_path in connections[from_pin_path]:
			var to_pin: Pin = get_node(to_pin_path)
			if to_pin and to_pin not in from_pin.connected_to:
				from_pin.connect_to(to_pin)

# ======================
# GENERATE UI FOR CHIP
# ----------------------
# This function instantiates the UI for the chip if required.
# It ensures UI separation and only creates it when necessary.
# ======================
func build_ui() -> void:
	if ui:
		return  # Prevent duplicate UI creation.
	ui = ChipUI.build_ui(schematic)
	ui.logic = self  # Assign logic reference to UI.

# ======================
# SYNTHESIZE CHIP FROM BLUEPRINT
# ----------------------
# This function takes blueprint data and initializes the chip.
# It configures logic, UI, pins, sub-chips, and wiring connections.
# The `render_level` determines whether UI should be generated.
# ======================
func synthesize(blueprint: ChipBlueprint, render_level: int) -> void:
	schematic = blueprint
	chip_name = blueprint.name
	name = blueprint.name
	chip_type = blueprint.type

	if render_level > 0:
		build_ui()

	# Instantiate sub-chips
	for sub_chip_schematic in blueprint.sub_chips:
		var sub_chip: Chip = get_chip(sub_chip_schematic.type)
		sub_chip_container.add_child(sub_chip)
		sub_chip.synthesize(sub_chip_schematic, render_level - 1)
		
		# Ensure UI is built when necessary
		if (render_level - 1 > 0 and ui) or (ui and sub_chip_schematic.type == ChipType.SEVENSEGMENT):
			sub_chip.build_ui()
			ui.sub_chip_container.add_child(sub_chip.ui)

	# Instantiate input pins
	for pin_data in blueprint.input_pins:
		var pin: Pin = build_pin(pin_data, render_level >= 0)
		input_container.add_child(pin)
		pin.name = pin_data.name
		input_pins.append(pin)
		
		# Build UI representation for pins if applicable
		if ui:
			pin.ui = PinUI.build_ui(pin)
			ui.input_container.add_child(pin.ui)
			pin.ui.name = pin.name

	# Instantiate output pins
	for pin_data in blueprint.output_pins:
		var pin: Pin = build_pin(pin_data, render_level >= 0)
		output_container.add_child(pin)
		pin.name = pin_data.name
		output_pins.append(pin)
		
		# Build UI representation for pins if applicable
		if ui:
			pin.ui = PinUI.build_ui(pin)
			ui.output_container.add_child(pin.ui)
			pin.ui.name = pin.name
			pin.ui.pin_color = schematic.description.background_color

	init()
	build_wiring(blueprint.connections)

# ======================
# DISCONNECT ALL CHIP CONNECTIONS
# ----------------------
# Clears connections between all input and output pins, removing all linked wires.
# ======================
func disconnect_chip() -> void:
	for pin in input_pins:
		pin.clear_connections()
	for pin in output_pins:
		pin.clear_connections()

# ======================
# CREATE A CHIP INSTANCE BASED ON TYPE
# ----------------------
# Instantiates and returns the appropriate chip type using preloaded scenes.
# ======================
static func get_chip(type: ChipType) -> Chip:
	match type:
		ChipType.SEVENSEGMENT:
			return seven_segment_logic_scene.instantiate()
		_:
			return chip_logic_scene.instantiate()
