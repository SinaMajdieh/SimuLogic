extends PopupMenu

enum MenueIds {
	EDIT,
}

func _ready() -> void:
	add_item("Edit",MenueIds.EDIT)


func _on_id_pressed(_id: int) -> void:
	$Popup.popup()
