extends PanelContainer

# ======================
# CHIP PLACEMENT UI CONTAINER:
# ----------------------
# This class dynamically manages the placement of chips within a container.
# It allows users to add, remove, and reposition chips while ensuring smooth UI interaction.
# ======================

# === CONSTANTS FOR CHIP SPACING ===
# Controls the minimum, maximum, and step size for chip separation.
const MAX_SEPARATION_VALUE: int = 200
const MIN_SEPARATION_VALUE: int = 0
const SEPARATION_STEP: int = 5

# === CHIP CONTAINER REFERENCE ===
# Holds chips before placement in the workbench.
@export var container: VBoxContainer

# ======================
# ADD CHIP TO CONTAINER
# ----------------------
# Instantiates a chip using its blueprint and adds it to the container.
# The chip logic is initialized, and its UI component is linked appropriately.
# ======================
func add_chip(bp: ChipBlueprint) -> void:
	var chip: Chip = Chip.get_chip(bp.type)  # Instantiate chip based on type
	chip.synthesize(bp, 1)  # Apply blueprint data and initialize logic
	container.add_child(chip.ui)  # Attach UI component
	chip.ui.name = bp.name  # Assign name from blueprint

func add_pin(pin: Pin) -> void:
	container.add_child(pin.ui)

# ======================
# CLOSE CHIP CONTAINER
# ----------------------
# Hides the container from view when it is visible.
# Used when no chips are left in the selection area.
# ======================
func close() -> void:
	if visible:
		visible = false

# ======================
# OPEN CHIP CONTAINER
# ----------------------
# Makes the container visible when hidden.
# Used when chips exist inside the selection.
# ======================
func open() -> void:
	if not visible:
		visible = true

# ======================
# UPDATE CHIP CONTAINER POSITION
# ----------------------
# Moves the container based on mouse movement.
# Keeps chips aligned with the cursor for smooth placement.
# If the container is empty, it is closed automatically.
# ======================
func _process(_delta: float) -> void:
	if container.get_child_count() == 0:
		close()
	else:
		open()
	global_position = get_global_mouse_position()  # Follow cursor movement

# ======================
# PLACE CHIPS IN WORKBENCH
# ----------------------
# Transfers all chips from the container into the workbench.
# Positions them based on their UI location at the time of placement.
# ======================
func place(_clicked_position: Vector2) -> void:
	for item in container.get_children():
		if item is ChipUI:
			var chip_position: Vector2 = item.global_position  # Retrieve chip position
			WorkBenchComm.add_chip(item.logic.schematic, chip_position)  # Add chip to workbench
		elif item is InteractablePin:
			WorkBenchComm.add_pin(item.logic.serialize(), item.global_position)

# ======================
# REMOVE ALL CHIPS
# ----------------------
# Clears all chips from the selection container.
# Ensures proper cleanup and memory management by freeing them.
# ======================
func remove_all() -> void:
	for item: Node in container.get_children():
		# if item is ChipUI:
		container.remove_child(item)
		item.queue_free()  # Free memory

# ======================
# HANDLE USER INPUT ACTIONS
# ----------------------
# Responds to user interactions such as scrolling (adjusting separation)
# and exiting (removing all chips from selection).
# ======================
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_scroll_up") and Input.is_action_pressed("ctr"):
		# Increase chip separation value (ensuring max limit)
		var separation: int = container.get_theme_constant("separation")
		separation = min(separation + SEPARATION_STEP, MAX_SEPARATION_VALUE)
		container.add_theme_constant_override("separation", separation)

	elif Input.is_action_just_pressed("ui_scroll_down") and Input.is_action_pressed("ctr"):
		# Decrease chip separation value (ensuring min limit)
		var separation: int = container.get_theme_constant("separation")
		separation = max(MIN_SEPARATION_VALUE, separation - SEPARATION_STEP)
		container.add_theme_constant_override("separation", separation)

	elif Input.is_action_just_pressed("ui_exit"):
		# Remove all chips from selection container
		remove_all()

# ======================
# INITIALIZE CHIP CONTAINER
# ----------------------
# Connects interaction signals to relevant functions upon startup.
# Ensures proper UI communication between selection and workbench.
# ======================
func _ready() -> void:
	InputBus.work_bench_clicked.connect(place)  # Handles chip placement in workbench
	Comm.import_chip_signal.connect(add_chip)  # Allows importing chips dynamically
