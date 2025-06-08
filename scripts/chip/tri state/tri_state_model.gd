class_name TriState
extends Chip

# ======================
# TRI-STATE LOGIC CHIP:
# ----------------------
# This class implements a tri-state buffer logic component.
# It controls whether the data signal is passed through or set to high impedance (Z).
# ======================

# === LOGIC CHIP SCENE REFERENCE ===
# Preloads the scene for tri-state logic processing.
static var tri_state_logic_scene: PackedScene = preload("res://scenes/chip/tri state/tri_state_logic.tscn")

# === PIN CONFIGURATION ===
# Defines the number of input and output pins required.
@export var input_size: int = 2
@export var output_size: int = 1

# ======================
# UPDATE TRI-STATE LOGIC
# ----------------------
# Determines the output state based on the enable pin and data input.
# ======================
func input_updated() -> void:
    var input: Array[LogicUtils.State] = get_input_array()

    # Validate pin count against defined schematic requirements
    if input_pins.size() < input_size or output_pins.size() < output_size:
        Logger.log_with_time(Logger.Logs.ERRORS, "Tri State pins don't match the schematic", true)
        return

    # Extract enable and data inputs
    var enable: LogicUtils.State = input[0]
    var data: LogicUtils.State = input[1]

    # Control output state based on enable pin
    if LogicUtils.is_high(enable):
        output_pins[0].state = data  # Pass data when enabled
    else:
        output_pins[0].state = LogicUtils.State.Z  # Set output to high impedance
