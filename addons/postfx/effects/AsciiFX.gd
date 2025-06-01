@tool
extends FXBase
class_name AsciiFX

@export var size : float = 1.0:
	set(value):
		size = value
		notify_change()

func _get_shader_code() -> String:
	properties["ascii_tex"] = preload("res://addons/postfx/assets/ascii.png")
	return load("res://addons/postfx/shaders/ascii.gdshader").code

func _update_shader() -> void:
	properties["ascii_tex"] = preload("res://addons/postfx/assets/ascii.png")
	properties["ascii_size"] = Vector2(8.0, 16.0) * size
