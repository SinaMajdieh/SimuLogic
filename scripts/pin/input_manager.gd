extends Node2D

@onready var menue: PopupMenu = $PopupMenu

func process_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == MOUSE_BUTTON_RIGHT:
			show_menue()

func show_menue() -> void:
	var last_mouse_postion = get_global_mouse_position()
	menue.popup(Rect2(
		last_mouse_postion.x, 
		last_mouse_postion.y,
		menue.size.x,
		menue.size.y
		))
