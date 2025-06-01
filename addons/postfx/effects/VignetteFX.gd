@tool
extends FXBase
class_name VignetteFX

@export var intensity : float = 0.4:
	set(value):
		intensity = value
		notify_change()

@export var color: Color = Color.BLACK:
	set(value):
		color = value
		notify_change()

func _get_shader_code() -> String:
	return load("res://addons/postfx/shaders/vignette.gdshader").code

func _update_shader() -> void:
	properties["vignette_intensity"] = intensity
	properties["vignette_rgb"] = color
