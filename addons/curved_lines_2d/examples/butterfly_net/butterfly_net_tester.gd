extends Control

@onready var net := $ButterflyNet

var _net_rotation_speed := 0.0

func _on_h_slider_value_changed(value: float) -> void:
	_net_rotation_speed = value


func _physics_process(delta: float) -> void:
	net.rotation += _net_rotation_speed * delta


func _on_check_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		net.scale.x = -1
	else:
		net.scale.x = 1
