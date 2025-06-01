@tool
extends FXBase
class_name DitherFX

func _get_shader_code() -> String:
	return load("res://addons/postfx/shaders/dither.gdshader").code

func _update_shader() -> void:
	pass
