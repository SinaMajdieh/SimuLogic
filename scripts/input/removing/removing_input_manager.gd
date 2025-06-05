extends InputMode

# ======================
# ELEMENT REMOVAL MODE:
# ----------------------
# This class handles the removal of wires, chips, and pins from the workbench.
# It ensures removal actions are only processed when the mode is active.
# ======================

# ======================
# REMOVE WIRE FROM WORKBENCH
# ----------------------
# Deletes a wire when clicked, provided the mode is active.
# ======================
func remove_wire(wire: Wire, _clicked_position: Vector2) -> void:
    if not is_active:
        return
    WorkBenchComm.remove_wire(wire)

# ======================
# REMOVE CHIP FROM WORKBENCH
# ----------------------
# Deletes a chip when clicked, provided the mode is active.
# ======================
func remove_chip(chip: ChipUI, _click_position: Vector2) -> void:
    if not is_active:
        return
    WorkBenchComm.remove_chip(chip)

# ======================
# REMOVE PIN FROM WORKBENCH
# ----------------------
# Deletes a pin when clicked, provided the mode is active.
# ======================
func remove_pin(pin: PinUI, _click_position: Vector2) -> void:
    if not is_active:
        return
    WorkBenchComm.remove_pin(pin)

# ======================
# INITIALIZE REMOVAL SIGNALS
# ----------------------
# Connects input events to corresponding removal functions at startup.
# ======================
func _ready() -> void:
    InputBus.wire_clicked.connect(remove_wire)
    InputBus.chip_clicked.connect(remove_chip)
    InputBus.pin_body_clicked.connect(remove_pin)
