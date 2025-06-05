class_name Canvas
extends Control

# ======================
# CANVAS CONTROL SYSTEM:
# ----------------------
# This class manages zoom and pan functionalities for an "infinite" workspace.
# It allows users to navigate the simulation efficiently.
# ======================

# === WORKSPACE REFERENCES ===
# Stores key UI components related to the canvas display.
@export var chips_canvas: WorkingBench  # Reference to the main working bench
@export var sub_viewport_container: SubViewportContainer  # Viewport container for rendering

# === UI ELEMENT REFERENCES ===
# Displays zoom level as user adjusts it.
@export var zoom_label: Label

# ======================
# SIGNAL DEFINITIONS
# ----------------------
# Emits a signal whenever the zoom level changes.
# ======================
signal zoom_changed(zoom_factor: float)

# ======================
# ZOOM CONTROL VARIABLES
# ----------------------
# Manages zoom functionality within defined limits.
# ======================
var zoom_factor: float = 1.0:
	set(value):
		zoom_factor = value
		zoom_label.text = "x%.2f" % zoom_factor  # Update UI label

const MIN_ZOOM: float = 0.2  # Minimum zoom level
const MAX_ZOOM: float = 3.0  # Maximum zoom level

# ======================
# PANNING STATE VARIABLES
# ----------------------
# Tracks panning interaction and movement state.
# ======================
var is_panning: bool = false
var last_mouse_pos: Vector2 = Vector2.ZERO

# ======================
# INITIALIZE CANVAS SYSTEM
# ----------------------
# Sets up the workspace with an initial zoom and ensures proper positioning.
# ======================
func _ready() -> void:
	# Set an oversized canvas to simulate an "infinite" workspace
	chips_canvas.custom_minimum_size = Vector2(100_000, 100_000)

	# Reset zoom and position values
	chips_canvas.scale = Vector2.ONE
	zoom_factor = 1.0

	# Wait one frame to ensure proper layout updates
	await get_tree().process_frame

	# Center the canvas within the viewport
	var container_size: Vector2 = sub_viewport_container.size
	var canvas_size: Vector2 = chips_canvas.custom_minimum_size
	chips_canvas.position = (container_size / 2.0) - (canvas_size / 2.0)

# ======================
# HANDLE USER INPUT EVENTS
# ----------------------
# Detects mouse interactions and applies zoom or pan accordingly.
# ======================
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				if event.pressed:
					zoom_by(0.1, event.position)
			MOUSE_BUTTON_WHEEL_DOWN:
				if event.pressed:
					zoom_by(-0.1, event.position)
			MOUSE_BUTTON_RIGHT:
				is_panning = event.pressed
				last_mouse_pos = event.position

	elif event is InputEventMouseMotion and is_panning:
		var delta: Vector2 = event.position - last_mouse_pos
		pan_by(delta)
		last_mouse_pos = event.position

# ======================
# APPLY ZOOM TRANSFORMATION
# ----------------------
# Adjusts zoom level and repositions canvas based on cursor location.
# ======================
func zoom_by(amount: float, mouse_pos: Vector2) -> void:
	var old_zoom: float = zoom_factor
	zoom_factor = clamp(zoom_factor + amount, MIN_ZOOM, MAX_ZOOM)
	var zoom_ratio: float = zoom_factor / old_zoom

	# Compute the position of the mouse in local canvas space before zooming
	var chip_canvas_local_mouse: Vector2 = (mouse_pos - chips_canvas.global_position) / old_zoom

	# Apply new zoom scale
	chips_canvas.scale = Vector2(zoom_factor, zoom_factor)

	# Adjust position to maintain zoom focus
	chips_canvas.position -= chip_canvas_local_mouse * (zoom_ratio - 1.0) * old_zoom

	# Emit zoom update signal
	zoom_changed.emit(zoom_factor)

# ======================
# APPLY PANNING TRANSFORMATION
# ----------------------
# Moves the canvas position to simulate camera movement.
# ======================
func pan_by(delta: Vector2) -> void:
	chips_canvas.position += delta
