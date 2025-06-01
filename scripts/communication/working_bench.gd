extends Node

@export var work_bench:WorkingBench = null

# Signals for wire-related events
signal wire_removed(wire: Wire)
signal wire_added(wire: Wire)

# Signals for exporting chip data
signal export_request(export_name: String, chip_color: Color)
signal import_request(schematic:ChipBlueprint)

# Signals for chip management
signal chip_added(schematic: ChipBlueprint, chip_position: Vector2)
signal chip_removed(chip: Chip)

# Signals for tracking pin count changes
signal input_pins_changed(amount: int)
signal output_pins_changed(amount: int)

# Emits a signal when a wire is removed
func remove_wire(wire: Wire) -> void:
    wire_removed.emit(wire)

# Emits a signal when a wire is added
func add_wire(wire: Wire) -> void:
    wire_added.emit(wire)

# Emits a signal when a chip needs to be exported
func export(export_name: String, chip_color: Color) -> void:
    export_request.emit(export_name, chip_color)
# Emits a signal when a chip needs to be imported
func import(schematic:ChipBlueprint) -> void:
    import_request.emit(schematic)


# Emits a signal when a new chip is added
func add_chip(schematic: ChipBlueprint, chip_position: Vector2) -> void:
    chip_added.emit(schematic, chip_position)

# Emits a signal when a chip is removed
func remove_chip(chip: Chip) -> void:
    chip_removed.emit(chip)

# Emits a signal when the number of input pins changes
func change_input_pins(amount: int) -> void:
    input_pins_changed.emit(amount)

# Emits a signal when the number of output pins changes
func change_output_pins(amount: int) -> void:
    output_pins_changed.emit(amount)
