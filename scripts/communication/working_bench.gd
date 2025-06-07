extends Node

# ======================
# WORKBENCH SETTINGS
# ----------------------
# This class acts as a communication hub for workbench interactions.
# It manages settings like grid visibility and spacing while emitting signals for various events.
# ======================

@export var work_bench: WorkingBench = null  # Reference to the main workbench instance

# Grid visibility toggle, triggering a redraw when changed
var show_grid: bool = false:
    set(value):
        show_grid = value
        work_bench.queue_redraw()

# Grid spacing setting, triggering a redraw when modified
var grid_spacing: int = 16:
    set(value):
        grid_spacing = value
        work_bench.queue_redraw()

# Wether to snap to grid or not
var snap_to_grid: bool = false

# ======================
# SIGNAL DEFINITIONS
# ----------------------
# These signals facilitate communication between components.
# Wires, chips, and pins trigger updates via these event emissions.
# ======================

# Signals for wire-related events
signal wire_removed(wire: Wire)
signal wire_added(wire: Wire)

# Signals for exporting and importing chip data
signal export_request(export_name: String, chip_color: Color)
signal import_request(schematic: ChipBlueprint)

# Signals for chip management (adding/removing chips)
signal chip_added(schematic: ChipBlueprint, chip_position: Vector2)
signal chip_removed(chip: ChipUI)

signal pin_added(pin_data: PinData, pin_position: Vector2)
signal pin_removed(pin: InteractablePin)

# Signals for tracking pin count adjustments
signal input_pins_changed(amount: int)
signal output_pins_changed(amount: int)

# ======================
# WIRE MANAGEMENT
# ----------------------
# Emits signals when a wire is added or removed.
# ======================

func remove_wire(wire: Wire) -> void:
    wire_removed.emit(wire)

func add_wire(wire: Wire) -> void:
    wire_added.emit(wire)

# ======================
# CHIP IMPORT/EXPORT
# ----------------------
# Emits signals when chip data needs to be imported or exported.
# ======================

func export(export_name: String, chip_color: Color) -> void:
    export_request.emit(export_name, chip_color)

func import(schematic: ChipBlueprint) -> void:
    import_request.emit(schematic)

# ======================
# CHIP MANAGEMENT
# ----------------------
# Handles signals for adding or removing chips dynamically.
# ======================

func add_chip(schematic: ChipBlueprint, chip_position: Vector2) -> void:
    chip_added.emit(schematic, chip_position)

func remove_chip(chip: ChipUI) -> void:
    chip_removed.emit(chip)


func add_pin(pin_data: PinData, pin_position: Vector2) -> void:
    pin_added.emit(pin_data, pin_position)

func remove_pin(pin: PinUI) -> void:
    pin_removed.emit(pin)

# ======================
# PIN COUNT TRACKING
# ----------------------
# Emits signals when input/output pin counts are modified.
# ======================

func change_input_pins(amount: int) -> void:
    input_pins_changed.emit(amount)

func change_output_pins(amount: int) -> void:
    output_pins_changed.emit(amount)

func toggle_snap_to_grid() -> void:
    WorkBenchComm.snap_to_grid = not WorkBenchComm.snap_to_grid

func toggle_grid() -> void:
    show_grid = not show_grid

func _ready() -> void:
    ShortcutManager.register_shortcut("snap_to_grid_shortcut", toggle_snap_to_grid)
    #! ShortcutMnager cant handle overlapping shortcuts for example 'CTR+G' also triggers 'CTR' and 'g' both
    #ShortcutManager.register_shortcut("grid_shortcut", toggle_grid)