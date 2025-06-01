extends Control

# SpinBox Nodes for adjusting input and output pin counts
@export var i_spinbox: SpinBox  # Controls number of input pins
@export var o_spinbox: SpinBox  # Controls number of output pins
@export var sim_frame_spinbox: SpinBox  # Controls simulation frame rate

# Resets values in the SpinBoxes to match the current WorkBench settings
func reset() -> void:
    i_spinbox.set_value(%WorkingBench.input_pin_count)  # Restore input pin count
    o_spinbox.set_value(%WorkingBench.output_pin_count)  # Restore output pin count

# Initializes UI and connects interaction signals
func _ready() -> void:
    reset()  # Ensure SpinBoxes start with correct values
    Comm.io_screen.connect(set_visible)  # Connect screen visibility toggle

# Applies changes when the user submits modifications
func _on_submit() -> void:
    # Update pin counts based on SpinBox values
    WorkBenchComm.change_input_pins(int(i_spinbox.value))
    WorkBenchComm.change_output_pins(int(o_spinbox.value))
    
    # Adjust simulation frame rate
    Comm.set_sim_frame(int(sim_frame_spinbox.value))
    
    # Hide the settings panel after applying changes
    visible = false

# Cancels modifications and restores default values
func _on_cancel() -> void:
    reset()  # Reset to previously stored values
    visible = false  # Hide settings panel
