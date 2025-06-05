class_name WorkingBench
extends PanelContainer

# ======================
# WORKBENCH MANAGEMENT:
# ----------------------
# This class manages the workbench environment for logic chip design.
# It supports blueprint creation, import/export, simulation control, and pin organization.
# ======================

# ======================
# GRID SETTINGS
# ----------------------
# Defines grid color and spacing properties for visualization.
# ======================
@export_category("Grid")
@export var grid_color = Color(0.3, 0.3, 0.3, 0.5)

# ======================
# WORKBENCH CONFIGURATION
# ----------------------
# Specifies the number of input and output pins.
# Stores blueprints of chips added to the workbench.
# ======================
@export_category("Work Bench")
@export var input_pin_count: int = 2
@export var output_pin_count: int = 1
@export var chip_blueprints: Array[ChipBlueprint] = []

# ======================
# UI CONTAINERS & SIGNALS
# ----------------------
# References containers for organizing pins, chips, and wires.
# ======================
@onready var input_pin_container: Control = $Container/Inputs
@onready var output_pin_container: Control = $Container/Outputs
@onready var sub_chips_container: Control = $Container/Chips
@export var wire_container: Node2D
@onready var input_manager: Node = $InputManager

# ======================
# SIMULATION FRAME SETTINGS
# ----------------------
# Defines the frame rate for logic simulation processing.
# ======================
@export_range(1, 10_000_000) var simulation_frame: int = 1

# ======================
# WORKBENCH STATE TRACKING
# ----------------------
# Manages workbench name and navigation history.
# Stores an instantiated chip reference.
# ======================
@onready var chip: Chip = Chip.chip_logic_scene.instantiate()
var work_bench_name: String = "Main"
var chip_stack: Array[ChipBlueprint] = []

# ======================
# NAVIGATION PATH RETRIEVAL
# ----------------------
# Returns the breadcrumb path for navigation history.
# ======================
func get_current_viewing_path() -> Array[String]:
	var path: Array[String] = []
	for i: int in range(chip_stack.size()):
		path.append(chip_stack[i].name)
	path.append(work_bench_name)
	return path

# ======================
# CHANGE SIMULATION FRAME LENGTH
# ----------------------
# Adjusts simulation frame duration while ensuring valid limits.
# ======================
func change_sim_frame(length: float) -> void:
	length = clamp(1, length, 10_000_000)
	simulation_frame = length

# ======================
# CONNECT WORKBENCH SIGNALS
# ----------------------
# Links key functions to external communications.
# ======================
func connect_signals() -> void:
	WorkBenchComm.work_bench = self
	WorkBenchComm.export_request.connect(export)
	WorkBenchComm.import_request.connect(import)
	%BreadCrumb.breadcrumb_clicked.connect(go_to_workbench)
	Comm.sim_frame_changed.connect(change_sim_frame)
	$PreciseTimer.time_out.connect(sim_frame_ended)

# ======================
# INITIALIZE WORKBENCH
# ----------------------
# Sets up signal connections, chip imports, and breadcrumb navigation.
# ======================
func _ready() -> void:
	connect_signals()

	# Import stored chip blueprints into workbench
	for bp in chip_blueprints:
		sub_chips_container.import_chip(bp)

	# Update breadcrumb navigation
	%BreadCrumb.set_path(get_current_viewing_path())

# ======================
# HANDLE WORKBENCH INPUT EVENTS
# ----------------------
# Detects user interactions for managing activity.
# ======================
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_left_click"):
		if get_global_rect().has_point(event.position):
			InputBus.notify_work_bench_clicked(event.position)
			input_manager.continue_processing_input()
		else:
			input_manager.stop_processing_input()

# ======================
# GENERATE CHIP BLUEPRINT
# ----------------------
# Constructs a chip schematic from the current workbench state.
# ======================
func generate_schematic(chip_name: String) -> ChipBlueprint:
	var bp: ChipBlueprint = ChipBlueprint.new()
	bp.name = chip_name
	bp.type = Chip.ChipType.COMPOSIT
	bp.input_pins = input_pin_container.get_pin_schematics()
	bp.output_pins = output_pin_container.get_pin_schematics()
	bp.sub_chips = sub_chips_container.get_chips_schematics()
	bp.connections = wire_container.get_wire_connections(Sim)

	# Serialize additional chip attributes
	bp.description = ChipDescription.new()
	bp.description.sub_chip_positions = sub_chips_container.get_sub_chips_positions()
	bp.description.wires = wire_container.get_wires_data()
	bp.description.input_pins_positions = input_pin_container.get_pins_positions()
	bp.description.output_pins_positions = output_pin_container.get_pins_positions()

	return bp

# ======================
# EXPORT CHIP BLUEPRINT
# ----------------------
# Saves the current workbench as a chip schematic.
# ======================
func export(chip_name: String, chip_color: Color) -> void:
	var bp: ChipBlueprint = generate_schematic(chip_name)
	bp.description.background_color = chip_color

	if bp.sub_chips.is_empty():
		print_debug("Working Bench is empty")
		return

	Arch.save_blueprint(bp, chip_name)
	Comm.add_chip_to_selection(bp)

	empty_workbench()
	input_pin_container.remove_pins()
	output_pin_container.remove_pins()

# ======================
# IMPORT CHIP BLUEPRINT
# ----------------------
# Loads a composit chip into the workbench.
# ======================
func import(schematic: ChipBlueprint, save_current: bool = true) -> void:
	if schematic.type != Chip.ChipType.COMPOSIT:
		Logger.log_with_time(Logger.Logs.ERRORS, "Chip %s is not of type composit" % schematic.name, true)
		return
	
	if save_current:
		var previous_chip: ChipBlueprint = generate_schematic(work_bench_name)
		chip_stack.append(previous_chip)
	
	empty_workbench()

	# Import pins, sub-chips, and wires
	input_pin_container.import_pins(schematic.input_pins, schematic.description.input_pins_positions)
	output_pin_container.import_pins(schematic.output_pins, schematic.description.output_pins_positions)
	sub_chips_container.import_chips(schematic.sub_chips, schematic.description.sub_chip_positions)
	wire_container.import_wires(schematic.description.wires)

	# Update navigation history
	work_bench_name = schematic.name
	%BreadCrumb.set_path(get_current_viewing_path())

# ======================
# NAVIGATE WORKBENCH HISTORY
# ----------------------
# Loads a previous workbench state from stored history.
# ======================
func go_to_workbench(index: int) -> void:
	if index >= chip_stack.size():
		Logger.log_with_time(Logger.Logs.ERRORS, "Cannot go back more, Chip Stack is empty", true)
		return
	
	var target_chip: ChipBlueprint = chip_stack[index]
	chip_stack.resize(index)
	import(target_chip, false)

# ======================
# CLEAR WORKBENCH
# ----------------------
# Removes all chips and wires from the workspace.
# ======================
func empty_workbench() -> void:
	wire_container.remove_all()
	input_pin_container.clear_connections()
	output_pin_container.clear_connections()
	sub_chips_container.remove_all()

# ======================
# PROCESS SIMULATION FRAME
# ----------------------
# Handles timed simulation updates dynamically.
# ======================
var next_process: bool = true

func sim_frame_ended() -> void:
	next_process = true

func _process(_delta: float) -> void:
	if next_process:
		get_tree().call_group("queued", "queued_update")
		Comm.update_frame += 1
		$PreciseTimer.start_timer(simulation_frame)
		next_process = false
