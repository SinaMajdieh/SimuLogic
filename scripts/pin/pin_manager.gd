extends Control

# ======================
# PIN CONTAINER MANAGER:
# ----------------------
# This class manages pins within a UI container.
# It supports adding, removing, importing, and retrieving schematic data for pins.
# ======================

# === PIN TYPE DEFINITION ===
# Determines whether the container handles input or output pins.
@export var type: Pin.PinType = Pin.PinType.INPUT

# ======================
# RETRIEVE PIN SCHEMATICS
# ----------------------
# Collects serialized schematic data for all pins in the container.
# ======================
func get_pin_schematics() -> Array[PinData]:
	var pin_schematics: Array[PinData] = []
	
	for pin in get_children():
		if pin is PinUI:
			pin_schematics.append(pin.logic.serialize())
	
	return pin_schematics

# ======================
# CLEAR ALL PIN CONNECTIONS
# ----------------------
# Removes all connections from pins safely.
# ======================
func clear_connections() -> void:
	for pin in get_children().duplicate():
		if pin is PinUI:
			pin.logic.clear_connections()

# ======================
# ADD NEW PIN TO CONTAINER
# ----------------------
# Instantiates and positions a pin using provided blueprint data.
# Supports absolute (global) or relative positioning.
# ======================
func add_pin(pin_data: PinData, pin_position: Vector2, global: bool = true) -> void:
	if pin_data.type != type:
		return

	var pin: Pin = Pin.pin_logic_scene.instantiate()
	pin.type = pin_data.type
	pin.name = pin_data.name
	pin.parent_chip = WorkBenchComm.work_bench.chip
	pin.build_ui(true)
	add_child(pin.ui)

	# Set position based on global or relative placement
	if global:
		pin.ui.global_position = pin_position
	else:
		pin.ui.position = pin_position
	
	Sim.add_io_pin(pin)
	pin.name = pin_data.name

# ======================
# RETRIEVE PIN NAMES
# ----------------------
# Collects and returns an array of pin names stored in the container.
# ======================
func get_pin_names() -> Array[String]:
	var names: Array[String] = []
	
	for pin: Node in get_children():
		if pin is PinUI:
			names.append(pin.name)
	
	return names

# ======================
# REMOVE SPECIFIC PIN
# ----------------------
# Deletes a pin and clears its connections before freeing memory.
# ======================
func remove_pin(pin: PinUI) -> void:
	if not has_node(str(pin.name)):
		return

	pin.logic.clear_connections()
	remove_child(pin)
	pin.queue_free()

# ======================
# REMOVE ALL PINS
# ----------------------
# Clears all pins from the container, ensuring proper cleanup.
# ======================
func remove_pins() -> void:
	for pin: PinUI in get_children():
		if pin is PinUI:
			remove_pin(pin)

# ======================
# IMPORT MULTIPLE PINS
# ----------------------
# Instantiates and positions multiple pins using blueprint data.
# ======================
func import_pins(pins_data: Array[PinData], positions: Array[Vector2]) -> void:
	for i: int in range(pins_data.size()):
		var pin_position: Vector2 = Vector2.ZERO

		# Use provided positions when available
		if i < positions.size():
			pin_position = positions[i]
		
		add_pin(pins_data[i], pin_position, false)

# ======================
# RETRIEVE PIN POSITIONS
# ----------------------
# Collects and returns a list of pin positions stored in the container.
# ======================
func get_pins_positions() -> Array[Vector2]:
	var positions: Array[Vector2] = []
	
	for pin: Node in get_children():
		if pin is PinUI:
			positions.append(pin.position)
	
	return positions    

# ======================
# INITIALIZE PIN INTERACTIONS
# ----------------------
# Connects signals for pin addition and removal upon startup.
# ======================
func _ready() -> void:
	WorkBenchComm.pin_added.connect(add_pin)
	WorkBenchComm.pin_removed.connect(remove_pin)
