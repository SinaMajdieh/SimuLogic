@tool
extends EditorInspectorPlugin

func _can_handle(obj) -> bool:
	return obj is DrawablePath2D


func _parse_property(object: Object, type: Variant.Type, name: String, hint_type: PropertyHint, hint_string: String, usage_flags: int, wide: bool) -> bool:
	if name == "line" and object is DrawablePath2D:
		var button : Button = Button.new()
		button.text = "Generate New Line2D"
		add_custom_control(button)
		button.pressed.connect(func(): _on_generate_line2d_button_pressed(object))
	elif name == "polygon" and object is DrawablePath2D:
		var button : Button = Button.new()
		button.text = "Generate New Polygon2D"
		add_custom_control(button)
		button.pressed.connect(func(): _on_generate_polygon2d_button_pressed(object))
	elif name == "collision_polygon" and object is DrawablePath2D:
		var button : Button = Button.new()
		button.text = "Generate New CollisionPolygon2D"
		add_custom_control(button)
		button.pressed.connect(func(): _on_generate_collision_polygon2d_button_pressed(object))
	return false


func _on_generate_line2d_button_pressed(drawable_path_2d : DrawablePath2D):
	var line_2d := Line2D.new()
	var root := EditorInterface.get_edited_scene_root()
	drawable_path_2d.add_child(line_2d, true)
	line_2d.set_owner(root)
	drawable_path_2d.line = line_2d


func _on_generate_polygon2d_button_pressed(drawable_path_2d : DrawablePath2D):
	var polygon_2d := Polygon2D.new()
	var root := EditorInterface.get_edited_scene_root()
	drawable_path_2d.add_child(polygon_2d, true)
	polygon_2d.set_owner(root)
	drawable_path_2d.polygon = polygon_2d


func _on_generate_collision_polygon2d_button_pressed(drawable_path_2d : DrawablePath2D):
	var collision_polygon_2d := CollisionPolygon2D.new()
	var root := EditorInterface.get_edited_scene_root()
	drawable_path_2d.add_child(collision_polygon_2d, true)
	collision_polygon_2d.set_owner(root)
	drawable_path_2d.collision_polygon = collision_polygon_2d
