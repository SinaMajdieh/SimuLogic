class_name WorkingBench
extends PanelContainer

# Defines the number of input and output pins
@export var input_pin_count: int = 2
@export var output_pin_count: int = 1

# Stores blueprints of chips added to the bench
@export var chip_blueprints: Array[ChipBlueprint] = []

# References containers for pins, chips, and wires
@onready var input_pin_container: VBoxContainer = $Container/Inputs
@onready var output_pin_container: VBoxContainer = $Container/Outputs
@onready var sub_chips_container: Control = $Container/Chips
@onready var wire_container: Node = $Wires
@onready var input_manager: Node = $InputManager

# Frame rate for simulation processing (scaled)
@export_range(0.001, 10) var simulation_frame: float = 0.001

# Stores the instantiated chip reference
@onready var chip: Chip = Chip.chip_scene.instantiate()

# Workbench name and history stack for blueprint navigation
var work_bench_name: String = "Main"
var chip_stack: Array[ChipBlueprint] = []

# Retrieves the breadcrumb path for navigation
func get_current_viewing_path() -> Array[String]:
    var path: Array[String] = []
    for i: int in range(chip_stack.size()):
        path.append(chip_stack[i].name)
    path.append(work_bench_name)
    return path

# Instantiates and adds input and output pins to their respective containers
func initiate_pins() -> void:
    input_pin_container.add_pins(input_pin_count)
    output_pin_container.add_pins(output_pin_count)

# Adjusts simulation frame length with proper clamping
func change_sim_frame(length: float) -> void:
    length = clamp(1, length, 10000)  # Ensure the value stays within limits
    simulation_frame = length * 0.001  # Scale frame duration

# Connects the required signals to methods
func connect_signals() -> void:
    WorkBenchComm.work_bench = self
    WorkBenchComm.input_pins_changed.connect(input_pin_container.change_pins)
    WorkBenchComm.output_pins_changed.connect(output_pin_container.change_pins)
    WorkBenchComm.export_request.connect(export)
    WorkBenchComm.import_request.connect(import)
    %BreadCrumb.breadcrumb_clicked.connect(go_to_workbench)
    Comm.sim_frame_changed.connect(change_sim_frame)

# Sets up initial signals and pins when the workbench is ready
func _ready() -> void:
    connect_signals()
    initiate_pins()

    # Import chip blueprints into the workbench
    for bp in chip_blueprints:
        sub_chips_container.import_chip(bp)

    # Update breadcrumb navigation
    %BreadCrumb.set_path(get_current_viewing_path())

# Handles input events to toggle workbench activity
func _input(event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_left_click"):
        if get_global_rect().has_point(event.position):  # Ensure input is within workbench bounds
            InputBus.notify_work_bench_clicked(event.position)
            input_manager.continue_processing_input()
        else:
            input_manager.stop_processing_input()

# Generates a chip blueprint from the current workbench state
func generate_schematic(chip_name: String) -> ChipBlueprint:
    var bp: ChipBlueprint = ChipBlueprint.new()
    bp.name = chip_name
    bp.type = Chip.ChipType.COMPOSIT
    bp.input_pins = input_pin_container.get_pin_schematics()
    bp.output_pins = output_pin_container.get_pin_schematics()
    bp.sub_chips = sub_chips_container.get_chips_schematics()
    bp.connections = wire_container.get_wire_connections(self)

    # Capture sub-chip and wire positions for serialization
    bp.description = ChipDescription.new()
    bp.description.sub_chip_positions = sub_chips_container.get_sub_chips_positions()
    bp.description.wires = wire_container.get_wires_data()

    return bp

# Exports the current workbench as a blueprint
func export(chip_name: String, chip_color: Color) -> void:
    var bp: ChipBlueprint = generate_schematic(chip_name)
    bp.description.background_color = chip_color

    if bp.sub_chips.is_empty():
        print_debug("Working Bench is empty")
        return

    # Save blueprint and register chip in selection
    Arch.save_blueprint(bp, chip_name)
    Comm.add_chip_to_selection(bp)
    empty_workbench()

# Opens a composit chip in the current workbench
func import(schematic: ChipBlueprint, save_current: bool = true) -> void:
    if schematic.type != Chip.ChipType.COMPOSIT:
        Logger.log_with_time(Logger.Logs.ERRORS, "Chip %s is not of type composit" % schematic.name, true)
        return
    
    # Save current state before importing a new chip
    if save_current:
        var previous_chip: ChipBlueprint = generate_schematic(work_bench_name)
        chip_stack.append(previous_chip)
    
    empty_workbench()

    # Import pins, sub-chips, and wires
    input_pin_container.remove_pins()
    input_pin_container.import_pins(schematic.input_pins)
    output_pin_container.remove_pins()
    output_pin_container.import_pins(schematic.output_pins)
    sub_chips_container.import_chips(schematic.sub_chips, schematic.description.sub_chip_positions)
    wire_container.import_wires(schematic.description.wires)

    # Update workbench name and breadcrumb navigation
    work_bench_name = schematic.name
    %BreadCrumb.set_path(get_current_viewing_path())

# Navigates to a previous workbench state from history
func go_to_workbench(index: int) -> void:
    if index >= chip_stack.size():
        Logger.log_with_time(Logger.Logs.ERRORS, "Cannot go back more, Chip Stack is empty", true)
        return
    
    # Restore workbench state from history
    var target_chip: ChipBlueprint = chip_stack[index]
    chip_stack.resize(index)
    import(target_chip, false)

# Clears the workbench, removing all chips and wires
func empty_workbench() -> void:
    wire_container.remove_all()
    input_pin_container.clear_connections()
    output_pin_container.clear_connections()
    sub_chips_container.remove_all()

# Signals the next simulation frame is ready for processing
func sim_frame_ended() -> void:
    next_process = true

# Tracks whether the next processing step should occur
var next_process: bool = true

# Handles timed simulation frame updates
func _process(_delta: float) -> void:
    if next_process:
        get_tree().call_group("queued", "queued_update")
        Comm.update_frame += 1
        $Timer.start(simulation_frame)
        next_process = false
