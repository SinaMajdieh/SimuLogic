extends ColorRect

var groupe_color: Color

var state:LogicUtils.State = LogicUtils.State.Z:
    set(value):
        state = value
        state_changed.emit(index)
        update_gui()

func update_gui() -> void:
    match state:
        LogicUtils.State.HIGH:
            color = ColorMan.get_glowing_color(groupe_color)
        LogicUtils.State.LOW:
            color = ColorMan.get_muted_color(groupe_color)
        LogicUtils.State.Z:
            color = Color.BLACK

var index: int = -1

signal state_changed(index: int)

func _gui_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_LEFT:
            state = LogicUtils.from_bool(not LogicUtils.to_bool(state))