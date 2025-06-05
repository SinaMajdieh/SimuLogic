class_name InputMode
extends Node

# ======================
# GENERIC INPUT MODE:
# ----------------------
# This class serves as the base for input modes in the system.
# It defines activation states and links to the input manager.
# ======================

# === MODE TYPE DEFINITION ===
# Specifies the mode type associated with this input mode.
@export var mode: InputManager.Mode

# === MODE ACTIVITY TRACKING ===
# Determines whether the mode is currently active.
var is_active: bool = false

# ======================
# ACTIVATE INPUT MODE
# ----------------------
# Enables the input mode, allowing interactions.
# ======================
func activate() -> void:
    is_active = true

# ======================
# DEACTIVATE INPUT MODE
# ----------------------
# Disables the input mode, stopping interactions.
# ======================
func deactivate() -> void:
    is_active = false
