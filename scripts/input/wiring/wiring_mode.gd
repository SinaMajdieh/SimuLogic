extends InputMode

# ======================
# WIRE INTERACTION MODE:
# ----------------------
# This class manages wire interaction in the workbench.
# It detects wire clicks, initializes previews, and finalizes wire connections.
# ======================

# === PIN WIRING MANAGER ===
# Handles wire connections between pins.
@onready var pin_wiring_manager: Node = $Pin

# === CLICKED WIRE TRACKING ===
# Stores the most recently interacted wire for processing.
var clicked_wire: Wire = null

# ======================
# DEACTIVATE WIRE INTERACTION MODE
# ----------------------
# Resets selections, cancels previews, and disables active mode.
# ======================
func diactivate() -> void:
	is_active = false
	pin_wiring_manager.selected_pin = null

	# Cancel existing wire previews
	if pin_wiring_manager.wire_preview:
		pin_wiring_manager.wire_preview.cancel()

	pin_wiring_manager.wire_preview = null

# ======================
# INITIALIZE WIRE INTERACTIONS
# ----------------------
# Connects wire click events upon startup.
# ======================
func _ready() -> void:
	InputBus.wire_clicked.connect(_on_wire_clicked)

# ======================
# HANDLE WIRE CLICK EVENTS
# ----------------------
# Determines whether to start a wire preview or modify an existing one.
# ======================
func _on_wire_clicked(wire: Wire, clicked_position: Vector2) -> void:
	if not is_active or not wire:
		return

	# Store the clicked wire only if none is currently selected
	if not clicked_wire:
		clicked_wire = wire

	# Ignore interactions for wires lower in the layer hierarchy
	# ! bug: if the code below in uncommented clicking on wire on a higher level and cancelling the clicking on a lower layer wire it won't go further so the wire wont be clicked
	# if wire.layer_index < clicked_wire.layer_index:
	#     return
	clicked_wire = wire
	pin_wiring_manager._start_preview(wire.source_pin.ui)

	# Iterate through wire segments, adding joints and stopping at the closest segment
	for i in range(0, wire.points.size() - 1):
		Comm.wire_preview.add_joint(wire.points[i])
		if is_point_on_segment(clicked_position, wire.points[i], wire.points[i + 1]):
			break

	# Set the next joint position based on the user's click location
	Comm.wire_preview.add_joint(clicked_position)
	Comm.wire_preview.next_joint = clicked_position

# ======================
# CHECK POINT ALIGNMENT ON SEGMENT
# ----------------------
# Verifies whether a point is approximately on a wire segment.
# Uses distance calculations with a configurable tolerance.
# ======================
func is_point_on_segment(point: Vector2, p1: Vector2, p2: Vector2, tolerance: float = 0.1) -> bool:
	var d1: float = point.distance_to(p1)
	var d2: float = point.distance_to(p2)
	var line_len: float = p1.distance_to(p2)

	# Ensures the sum of distances is approximately equal to the line length within tolerance
	return abs((d1 + d2) - line_len) <= tolerance
