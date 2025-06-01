extends InputMode

# Removes a wire if the mode is active
func remove_wire(wire: Wire, _clicked_position: Vector2) -> void:
    if not is_active:
        return
    WorkBenchComm.remove_wire(wire)

# Removes a chip if the mode is active
func remove_chip(chip: Chip, _click_position: Vector2) -> void:
    if not is_active:
        return
    WorkBenchComm.remove_chip(chip)

# Connects input events to removal functions upon initialization
func _ready() -> void:
    InputBus.wire_clicked.connect(remove_wire)
    InputBus.chip_clicked.connect(remove_chip)
