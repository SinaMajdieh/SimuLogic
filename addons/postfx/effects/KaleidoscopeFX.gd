@tool
extends FXBase
class_name KaleidoscopeFX

# Segment Controls
@export_group("Segments")
@export_range(2, 48, 1) var segments: float = 6.0:
	set(value):
		segments = value
		notify_change()

@export var segment_reflect: bool = true:
	set(value):
		segment_reflect = value
		notify_change()

# Polar Coordinates
@export_group("Polar Coordinates")
@export var polar_offset: Vector2 = Vector2(0.5, 0.5):
	set(value):
		polar_offset = value
		notify_change()

@export_range(0, 360) var polar_angle: float = 0.0:
	set(value):
		polar_angle = value
		notify_change()

# Source Image
@export_group("Source Image")
@export var source_offset: Vector2 = Vector2(0.5, 0.5):
	set(value):
		source_offset = value
		notify_change()

@export var source_scale: float = 2.0:
	set(value):
		source_scale = value
		notify_change()

@export_range(0, 360) var source_angle: float = 0.0:
	set(value):
		source_angle = value
		notify_change()

func _get_shader_code() -> String:
	return load("res://addons/postfx/shaders/kaleidoscope.gdshader").code

func _update_shader() -> void:
	# Segment Controls
	properties["segments"] = segments
	properties["segmentReflect"] = segment_reflect
	
	# Polar Coordinates
	properties["polarOffset"] = polar_offset
	properties["polarAngle"] = polar_angle
	
	# Source Image
	properties["sourceOffset"] = source_offset
	properties["sourceScale"] = source_scale
	properties["sourceAngle"] = source_angle
