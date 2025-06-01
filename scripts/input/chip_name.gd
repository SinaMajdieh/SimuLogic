extends TextEdit

## Handles input events to manage text field focus.
func _input(event: InputEvent) -> void:
	if not has_focus():
		return

	if event is InputEventMouseButton and event.is_pressed():
		if not get_global_rect().has_point(event.position):
			release_focus()
