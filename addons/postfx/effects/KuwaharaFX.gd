@tool
extends FXBase
class_name KuwaharaFX

# Kernel Settings
@export_group("Kernel Configuration")
@export_range(2, 20, 1) var kernel_size: int = 2:
	set(value):
		kernel_size = value
		notify_change()

# Filter Quality
@export_group("Filter Quality")
@export_range(1.0, 100.0) var hardness: float = 8.0:
	set(value):
		hardness = value
		notify_change()

@export_range(1.0, 18.0) var sharpness: float = 8.0:
	set(value):
		sharpness = value
		notify_change()

# Advanced Tuning
@export_group("Advanced Tuning")
@export_range(0.01, 2.0) var zero_crossing: float = 0.58:
	set(value):
		zero_crossing = value
		notify_change()

@export_range(0.01, 3.0) var zeta: float = 1.0:
	set(value):
		zeta = value
		notify_change()

func _get_shader_code() -> String:
	return load("res://addons/postfx/shaders/kuwahara.gdshader").code

func _update_shader() -> void:
	# Kernel Settings
	properties["_KernelSize"] = kernel_size
	
	# Filter Quality
	properties["_Hardness"] = hardness
	properties["_Sharpness"] = sharpness
	
	# Advanced Tuning
	properties["_ZeroCrossing"] = zero_crossing
	properties["_Zeta"] = zeta
