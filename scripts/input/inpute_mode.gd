class_name InputMode
extends Node

## Defines the mode type associated with this input mode.
@export var mode: InputManager.Mode

## Tracks whether this mode is active.
var is_active: bool = false

## Activates the input mode.
func activate() -> void:
	is_active = true

## Deactivates the input mode.
func deactivate() -> void:
	is_active = false
