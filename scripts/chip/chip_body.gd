extends VBoxContainer

# Retrieves the associated Chip node from the parent structure
@onready var chip: Chip = get_parent().get_parent()

# Processes input events, specifically handling mouse clicks
func _input(event: InputEvent) -> void:
	# Ensure the chip reference is valid before proceeding
	if chip == null:
		return

	# Detect left-click action and verify the event occurred within this node’s boundaries
	if Input.is_action_just_pressed("ui_left_click") and get_global_rect().has_point(event.position):
		# Notify InputBus that this chip has been clicked, passing its position
		InputBus.notify_chip_clicked(chip, event.position)
	# Detect right-click action and verify the event occurred within this node’s boundaries
	elif Input.is_action_just_pressed("ui_right_click") and get_global_rect().has_point(event.position):
		# Notify WorkBenchComm that this chip has been right-clicked, passing its schematic
		WorkBenchComm.import(chip.schematic)
