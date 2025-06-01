@tool
extends FXBase
class_name ColorCorrectionFX

@export var tint : Color = Color.WHITE:
	set(value):
		tint = value
		notify_change()

@export_range(-1.0, 1.0, 0.01) var brightness : float = 0.0:
	set(value):
		brightness = value
		notify_change()

@export_range(-1.0, 1.0, 0.01) var saturation : float = 0.0:
	set(value):
		saturation = value
		notify_change()

func _get_shader_code() -> String:
	return load("res://addons/postfx/shaders/color_correction.gdshader").code

func _update_shader() -> void:
	properties["tint"] = tint
	properties["brightness"] = brightness
	properties["saturation"] = saturation
