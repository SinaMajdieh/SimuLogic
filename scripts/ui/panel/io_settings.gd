extends Control

# ======================
# SIMULATION SETTINGS UI:
# ----------------------
# This class manages user-defined simulation parameters, including frame rate and grid visibility.
# It allows users to adjust settings dynamically and apply changes to the workbench.
# ======================

# === UI ELEMENT REFERENCES ===
# Defines interactive components for simulation settings adjustments.
@export var sim_frame_spinbox: SpinBox  # Controls simulation frame rate
@export var grid_spacing_spinbox: SpinBox  # Controls grid spacing
@export var show_grid_checkbox: CheckButton  # Toggles grid visibility

# ======================
# RESET SIMULATION SETTINGS
# ----------------------
# Resets UI values to match the current workbench configuration.
# ======================
func reset() -> void:
    sim_frame_spinbox.set_value(WorkBenchComm.work_bench.simulation_frame)
    grid_spacing_spinbox.set_value(WorkBenchComm.grid_spacing)
    show_grid_checkbox.button_pressed = WorkBenchComm.show_grid

# ======================
# TOGGLE SETTINGS SCREEN VISIBILITY
# ----------------------
# Opens or closes the simulation settings panel.
# Resets values when displayed.
# ======================
func screen_state(open: bool) -> void:
    reset()
    visible = open

# ======================
# INITIALIZE SETTINGS UI
# ----------------------
# Ensures initial values are correct and connects interaction signals.
# ======================
func _ready() -> void:
    reset()  # Ensure SpinBoxes start with correct values
    Comm.io_screen.connect(screen_state)  # Connect screen visibility toggle

# ======================
# APPLY USER-DEFINED SETTINGS
# ----------------------
# Updates simulation parameters when changes are submitted.
# ======================
func _on_submit() -> void:
    Comm.set_sim_frame(int(sim_frame_spinbox.value))  # Update simulation frame rate
    WorkBenchComm.grid_spacing = int(grid_spacing_spinbox.value)  # Apply grid spacing
    WorkBenchComm.show_grid = show_grid_checkbox.button_pressed  # Update grid visibility

    visible = false  # Hide settings panel after applying changes

# ======================
# CANCEL SETTINGS CHANGES
# ----------------------
# Restores previous settings and hides the panel.
# ======================
func _on_cancel() -> void:
    reset()  # Reset to previously stored values
    visible = false
