extends MarginContainer

# ======================
# INPUT MODE BUTTON PANEL:
# ----------------------
# This class manages a set of buttons for toggling input modes.
# It updates button states dynamically based on mode changes.
# ======================

# === BUTTON CONTAINER ===
# Stores an array of buttons used for selecting input modes.
@export var buttons: Array[Button] = []

# ======================
# UPDATE BUTTON STATES BASED ON MODE
# ----------------------
# Sets the pressed state for buttons corresponding to the active mode.
# ======================
func change_mode(mode: InputManager.Mode) -> void:
    for button: Button in buttons:
        button.button_pressed = (button.mode == mode)

# ======================
# INITIALIZE BUTTON CONNECTIONS
# ----------------------
# Connects button signals and synchronizes mode states upon startup.
# ======================
func _ready() -> void:
    for button in buttons:
        button.change_mode.connect(update_input_mode)
    InputManager.mode_changed.connect(change_mode)
    change_mode(InputManager.current_mode)

# ======================
# HANDLE INPUT MODE CHANGES
# ----------------------
# Updates the active input mode when a button is pressed.
# ======================
func update_input_mode(mode: InputManagerClass.Mode) -> void:
    InputManager.update_active_mode(mode)
