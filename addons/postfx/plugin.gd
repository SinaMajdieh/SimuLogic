@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("PostFX", "CanvasLayer", preload("res://addons/postfx/nodes/PostFX.gd"), preload("res://addons/postfx/assets/postfx_node.svg"))


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass
