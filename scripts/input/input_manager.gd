class_name InputManager
extends Node

# Defines the available input modes
enum Mode {WIRING, MOVING, REMOVING}

# Tracks the current input mode
var current_mode: Mode = Mode.WIRING

# Determines whether input processing is active
var is_active: bool = true

# Updates the active input mode and applies changes to child InputMode nodes
func update_active_mode(mode: Mode) -> void:
    current_mode = mode
    
    for input_mode in get_children():
        var mode_instance: InputMode = input_mode as InputMode
        if mode_instance:
            if mode_instance.mode == current_mode:
                mode_instance.activate()
            else:
                mode_instance.deactivate()

# Handles input events to toggle input modes
func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_pressed():
        toggle_mode(event.keycode)

# Toggles the input mode based on key presses
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

# Initializes the input manager and sets the default mode
func _ready() -> void:
    update_active_mode(current_mode)

# Stops input processing and deactivates all input modes
func stop_processing_input() -> void:
    is_active = false
    
    for input_mode in get_children():
        var mode_instance: InputMode = input_mode as InputMode
        if mode_instance:
            mode_instance.deactivate()

# Resumes input processing and reactivates the current mode
func continue_processing_input() -> void:
    is_active = true
    update_active_mode(current_mode)
