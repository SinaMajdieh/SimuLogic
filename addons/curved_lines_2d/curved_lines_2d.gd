@tool
extends EditorPlugin

var plugin
var svg_importer_dock

func _enter_tree():
	svg_importer_dock = preload("res://addons/curved_lines_2d/svg_importer_dock.tscn").instantiate()
	plugin = preload("res://addons/curved_lines_2d/line_2d_generator_inspector_plugin.gd").new()
	add_inspector_plugin(plugin)
	add_custom_type(
		"DrawablePath2D", 
		"Path2D", 
		preload("res://addons/curved_lines_2d/drawable_path_2d.gd"),
		preload("res://addons/curved_lines_2d/DrawablePath2D.svg")
	)
	svg_importer_dock.undo_redo = get_undo_redo()
	add_control_to_bottom_panel(svg_importer_dock as Control, "EZ SVG Importer")


func _exit_tree():
	remove_inspector_plugin(plugin)
	remove_custom_type("DrawablePath2D")
	remove_control_from_bottom_panel(svg_importer_dock)
	svg_importer_dock.free()
