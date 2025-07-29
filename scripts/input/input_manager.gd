class_name InputManagerClass
extends Node

# ======================
# INPUT MODE MANAGEMENT:
# ----------------------
# This class controls input handling and toggles between different interaction modes.
# It supports wiring, moving, and removing components dynamically.
# ======================

# === INPUT MODE ENUMERATION ===
# Defines available input modes for user interaction.
enum Mode {WIRING, MOVING, REMOVING}

# === SIGNAL DEFINITIONS ===
# Notifies when the input mode has changed.
signal mode_changed(mode: Mode)

# === ACTIVE INPUT MODE TRACKING ===
# Stores the currently selected input mode.
var current_mode: Mode = Mode.WIRING:
    set(value):
        current_mode = value
        mode_changed.emit(current_mode)

# === INPUT PROCESSING STATUS ===
# Determines if input handling is enabled or disabled.
var is_active: bool = true

# ======================
# SWITCH ACTIVE INPUT MODE
# ----------------------
# Updates the mode and applies changes to child InputMode instances.
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
# Detects user key presses and toggles input modes accordingly.
# ======================
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_pressed():
        toggle_mode(event.keycode)

# ======================
# TOGGLE INPUT MODE VIA KEY PRESS
# ----------------------
# Switches between interaction modes based on specific key inputs.
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
# Sets the default input mode when the scene is loaded.
# ======================
func _ready() -> void:
    update_active_mode(current_mode)

# ======================
# DISABLE INPUT HANDLING
# ----------------------
# Stops processing input and deactivates all input modes.
# ======================
func stop_processing_input() -> void:
    is_active = false
    
    for input_mode in get_children():
        var mode_instance: InputMode = input_mode as InputMode
        if mode_instance:
            mode_instance.deactivate()

# ======================
# ENABLE INPUT HANDLING
# ----------------------
# Resumes input processing and reactivates the last selected mode.
# ======================
func continue_processing_input() -> void:
    is_active = true
    update_active_mode(current_mode)