extends MenuButton

func _ready() -> void:
	get_popup().id_pressed.connect(_on_pressed)

enum items {CREATE, IO}

## Handles workbench export when the button is pressed.
func _on_pressed(id:int) -> void:
	match id:
		items.CREATE:
			Comm.set_export_screen()
		items.IO:
			Comm.set_io_screen_screen()
