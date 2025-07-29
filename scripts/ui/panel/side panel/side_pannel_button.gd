extends Button

# ======================
# INPUT MODE BUTTON:
# ----------------------
# This class represents a button for switching input modes.
# It emits a signal when pressed to update the selected mode.
# ======================

# === MODE CONFIGURATION ===
# Stores the associated input mode for this button.
@export var mode: InputManagerClass.Mode

# === SIGNAL DEFINITIONS ===
# Emits an event when the button is pressed, changing the mode.
signal change_mode(mode: InputManagerClass.Mode)

# ======================
# HANDLE BUTTON PRESS
# ----------------------
# Emits the mode change signal when pressed.
# ======================
func _on_pressed() -> void:
    change_mode.emit(mode)

# ======================
# CONNECT BUTTON EVENT
# ----------------------
# Links the press event to trigger the mode change signal.
# ======================
func _ready() -> void:
    pressed.connect(_on_pressed)
