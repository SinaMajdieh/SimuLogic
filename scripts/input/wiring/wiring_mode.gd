extends InputMode

@onready var pin_wiring_manager : Node = $Pin

func diactivate() -> void:
	is_active = false
	pin_wiring_manager.selected_pin = null
	if pin_wiring_manager.wire_preview:
		pin_wiring_manager.wire_preview.cancel()
	pin_wiring_manager.wire_preview = null

func _ready() -> void:
	InputBus.wire_clicked.connect(_on_wire_clicked)


func _on_wire_clicked(wire : Wire, clicked_position:Vector2) -> void:
	if not is_active or pin_wiring_manager.wire_preview:
		return
	pin_wiring_manager._start_preview(wire.source_pin)
	for i in range(0, wire.points.size()-1):
		if is_point_between(clicked_position, wire.points[i], wire.points[i + 1]):
			break
		pin_wiring_manager.wire_preview.add_joint(wire.points[i])

	pin_wiring_manager.wire_preview.next_joint = clicked_position


func is_point_between(p: Vector2, a: Vector2, b: Vector2) -> bool:
	# Check if P lies within the axis-aligned bounds of A and B
	var within_bounds = (
		p.x >= min(a.x, b.x) and p.x <= max(a.x, b.x) and
		p.y >= min(a.y, b.y) and p.y <= max(a.y, b.y)
	)

	# Check if A, B, and P are colinear using cross product
	var ab = b - a
	var ap = p - a
	var cross = ab.cross(ap)

	return within_bounds and abs(cross) < 0.01  # 0.01 = small tolerance
