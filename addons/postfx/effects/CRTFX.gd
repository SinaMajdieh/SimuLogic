@tool
extends FXBase
class_name CRTShaderFX

# Display Settings
var overlay: bool = true:
	set(value):
		overlay = value
		notify_change()

@export var resolution: Vector2 = Vector2(640, 480):
	set(value):
		resolution = value
		notify_change()

@export var brightness: float = 1.4:
	set(value):
		brightness = value
		notify_change()

# Scanline Settings
@export_range(0.0, 1.0) var scanlines_opacity: float = 0.4:
	set(value):
		scanlines_opacity = value
		notify_change()

@export_range(0.0, 0.5) var scanlines_width: float = 0.25:
	set(value):
		scanlines_width = value
		notify_change()

@export_range(0.0, 1.0) var grille_opacity: float = 0.3:
	set(value):
		grille_opacity = value
		notify_change()

# Distortion Settings
@export var roll: bool = true:
	set(value):
		roll = value
		notify_change()

@export var roll_speed: float = 8.0:
	set(value):
		roll_speed = value
		notify_change()

@export_range(0.0, 100.0) var roll_size: float = 15.0:
	set(value):
		roll_size = value
		notify_change()

@export_range(0.1, 5.0) var roll_variation: float = 1.8:
	set(value):
		roll_variation = value
		notify_change()

@export_range(0.0, 0.2) var distort_intensity: float = 0.05:
	set(value):
		distort_intensity = value
		notify_change()

@export_range(-1.0, 1.0) var aberration: float = 0.03:
	set(value):
		aberration = value
		notify_change()

# Noise Settings
@export_range(0.0, 1.0) var noise_opacity: float = 0.4:
	set(value):
		noise_opacity = value
		notify_change()

@export var noise_speed: float = 5.0:
	set(value):
		noise_speed = value
		notify_change()

@export_range(0.0, 1.0) var static_noise_intensity: float = 0.06:
	set(value):
		static_noise_intensity = value
		notify_change()

# Additional Effects
@export var pixelate: bool = true:
	set(value):
		pixelate = value
		notify_change()

@export var discolor: bool = true:
	set(value):
		discolor = value
		notify_change()

@export_range(0.0, 5.0) var warp_amount: float = 1.0:
	set(value):
		warp_amount = value
		notify_change()

@export var clip_warp: bool = false:
	set(value):
		clip_warp = value
		notify_change()

@export var vignette_intensity: float = 0.4:
	set(value):
		vignette_intensity = value
		notify_change()

@export_range(0.0, 1.0) var vignette_opacity: float = 0.5:
	set(value):
		vignette_opacity = value
		notify_change()

func _get_shader_code() -> String:
	return load("res://addons/postfx/shaders/crt.gdshader").code

func _update_shader() -> void:
	# Display Settings
	properties["overlay"] = overlay
	properties["resolution"] = resolution
	properties["brightness"] = brightness
	
	# Scanline Settings
	properties["scanlines_opacity"] = scanlines_opacity
	properties["scanlines_width"] = scanlines_width
	properties["grille_opacity"] = grille_opacity
	
	# Distortion Settings
	properties["roll"] = roll
	properties["roll_speed"] = roll_speed
	properties["roll_size"] = roll_size
	properties["roll_variation"] = roll_variation
	properties["distort_intensity"] = distort_intensity
	properties["aberration"] = aberration
	
	# Noise Settings
	properties["noise_opacity"] = noise_opacity
	properties["noise_speed"] = noise_speed
	properties["static_noise_intensity"] = static_noise_intensity
	
	# Additional Effects
	properties["pixelate"] = pixelate
	properties["discolor"] = discolor
	properties["warp_amount"] = warp_amount
	properties["clip_warp"] = clip_warp
	properties["vignette_intensity"] = vignette_intensity
	properties["vignette_opacity"] = vignette_opacity
