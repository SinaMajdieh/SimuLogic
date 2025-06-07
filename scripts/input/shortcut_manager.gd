extends Node

# ======================
# SHORTCUT MANAGEMENT SYSTEM:
# ----------------------
# This class registers, unregisters, and handles shortcut actions dynamically.
# It listens for keyboard inputs and triggers associated callbacks.
# ======================

# === STORED SHORTCUT ACTIONS ===
# Dictionary mapping shortcut names to their callback functions and arguments.
var shortcut_actions: Dictionary = {}

# ======================
# REGISTER SHORTCUT ACTION
# ----------------------
# Stores a shortcut action with its corresponding callback and arguments.
# ======================
func register_shortcut(action_name: String, callback: Callable, args: Array = []) -> void:
    shortcut_actions[action_name] = [callback, args]

# ======================
# UNREGISTER SHORTCUT ACTION
# ----------------------
# Removes a shortcut action from storage.
# ======================
func unregister_shortcut(action_name: String) -> void:
    shortcut_actions.erase(action_name)

# ======================
# HANDLE SHORTCUT INPUT EVENTS
# ----------------------
# Detects keyboard input and triggers associated shortcut actions.
# ======================
func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventKey and event.is_pressed and not event.is_echo():
        for action_name: String in shortcut_actions.keys():
            if Input.is_action_just_pressed(action_name):
                var entry: Array = shortcut_actions[action_name]
                var callback: Callable = entry[0]
                var args: Array = entry[1]

                # Validate and execute the callback function
                if callback.is_valid():
                    callback.callv(args)
