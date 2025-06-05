class_name PanelBase
extends Control

# ======================
# RESET SIMULATION SETTINGS
# ----------------------
# Resets UI values to match the current workbench configuration.
# ======================
func reset() -> void:
    return

# ======================
# TOGGLE SETTINGS SCREEN VISIBILITY
# ----------------------
# Opens or closes the simulation settings panel.
# Resets values when displayed.
# ======================
func set_open(open: bool) -> void:
    reset()
    visible = open

