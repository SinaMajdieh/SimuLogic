@tool
extends Resource
class_name FXBase

@export var enabled: bool = true:
	set(value):
		enabled = value
		notify_change()


var properties : Dictionary

func _get_shader_code() -> String:
	push_error("NO SHADER CODE PROVIDED.")
	return ""

func _update_shader() -> void:
	pass

func notify_change():
	changed.emit()
