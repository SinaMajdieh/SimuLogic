class_name InputManager
extends Node

# ======================
# INPUT MODE MANAGEMENT:
# ----------------------
# This class manages different input modes for user interactions.
# It toggles between wiring, moving, and removing modes dynamically.
# ======================

# === INPUT MODE ENUMERATION ===
# Defines available input modes for interaction.
enum Mode {WIRING, MOVING, REMOVING}

# === CURRENT MODE TRACKING ===
# Stores the active input mode.
var current_mode: Mode = Mode.WIRING

# === INPUT PROCESSING STATUS ===
# Controls whether input handling is currently enabled.
var is_active: bool = true

# ======================
# UPDATE ACTIVE INPUT MODE
# ----------------------
# Switches to a new input mode and applies the changes to child InputMode instances.
# ======================
func update_active_mode(mode: Mode) -> void:
    current_mode = mode
    
    for input_mode in get_children():
        var mode_instance: InputMode = input_mode as InputMode
        if mode_instance:
            if mode_instance.mode == current_mode:
                mode_instance.activate()
            else:
                mode_instance.deactivate()

# ======================
# HANDLE INPUT EVENTS
# ----------------------
# Detects key presses and toggles input modes accordingly.
# ======================
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_pressed():
        toggle_mode(event.keycode)

# ======================
# TOGGLE INPUT MODE
# ----------------------
# Switches between different input modes when specific keys are pressed.
# ======================
func toggle_mode(keycode: Key) -> void:
    if not is_active:
        return
    
    match keycode:
        KEY_W:
            update_active_mode(Mode.WIRING)
        KEY_M:
            update_active_mode(Mode.MOVING)
        KEY_R:
            update_active_mode(Mode.REMOVING)

# ======================
# INITIALIZE INPUT MANAGER
# ----------------------
# Sets the default input mode upon startup.
# ======================
func _ready() -> void:
    update_active_mode(current_mode)

# ======================
# STOP INPUT PROCESSING
# ----------------------
# Disables input handling and deactivates all input modes.
# ======================
func stop_processing_input() -> void:
    is_active = false
    
    for input_mode in get_children():
        var mode_instance: InputMode = input_mode as InputMode
        if mode_instance:
            mode_instance.deactivate()

# ======================
# RESUME INPUT PROCESSING
# ----------------------
# Enables input handling and reactivates the last selected mode.
# ======================
func continue_processing_input() -> void:
    is_active = true
    update_active_mode(current_mode)
