extends ColorRect

# ======================
# PIN BODY INTERACTION:
# ----------------------
# This class handles mouse interactions for the pin UI body.
# It detects clicks, hover events, and communicates with the input bus accordingly.
# ======================

# === PIN UI REFERENCE ===
# Stores the UI component associated with the pin.
@export var ui: InteractablePin

# ======================
# HANDLE INPUT EVENTS
# ----------------------
# Detects mouse clicks and triggers corresponding notifications.
# ======================
func _input(event: InputEvent) -> void:
	# Ensure the pin reference is valid before processing input
	if ui == null:
		return

	# Detect left-click and verify the event occurred within this node's boundaries
	if Input.is_action_just_pressed("ui_left_click"):
		if get_global_rect().has_point(event.position):
			InputBus.notify_pin_body_clicked(ui, event.position)  # Notify pin selection
	
	# Detect right-click and verify the event occurred within this node's boundaries
	elif Input.is_action_just_pressed("ui_right_click"):
		if get_global_rect().has_point(event.position):
			pass  # Reserved for future interactions

# ======================
# HANDLE MOUSE HOVER EVENTS
# ----------------------
# Adjusts pin transparency to provide visual feedback.
# ======================
func _on_mouse_entered() -> void:
	ui.modulate.a = 0.5  # Reduce transparency when hovered

func _on_mouse_exited() -> void:
	ui.modulate.a = 1  # Restore full transparency when unhovered
