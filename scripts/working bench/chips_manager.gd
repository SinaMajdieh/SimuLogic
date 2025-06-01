extends Control

# Imports a chip blueprint and instantiates a chip node
func import_chip(bp: ChipBlueprint) -> void:
    var sub_chip_node: Chip = Chip.chip_scene.instantiate()
    add_child(sub_chip_node)
    
    # Initializes the chip using its blueprint
    sub_chip_node.synthesize(bp, 1)

# Retrieves the schematics of all chips currently present in the scene
func get_chips_schematics() -> Array[ChipBlueprint]:
    var schematics: Array[ChipBlueprint] = []
    
    # Iterate through child nodes and collect chip schematics
    for chip: Node in get_children():
        if not chip is Chip:
            continue
        chip = chip as Chip  # Explicitly cast the node to Chip type
        schematics.append(chip.schematic)  # Store the chip's schematic
    
    return schematics

# Adds a chip to the workbench and assigns its blueprint
func add_chip(schematic: ChipBlueprint, chip_position: Vector2) -> void:
    var chip: Chip = Chip.chip_scene.instantiate()
    add_child(chip)
    
    # Initialize the chip and position it correctly
    chip.synthesize(schematic, 1)
    chip.global_position = chip_position

# Removes a specific chip from the workbench
func remove_chip(chip: Chip) -> void:
    if not chip:
        return
    
    # Ensure the chip exists before attempting removal
    if has_node(String(chip.name)):
        chip.disconnect_chip()  # Disconnect all associated links
        remove_child(chip)
        chip.queue_free()  # Free the chip from memory

# Removes all chips from the workbench
func remove_all() -> void:
    for chip: Node in get_children().duplicate():  # Ensure safe removal during iteration
        if chip is Chip:
            remove_chip(chip)

# Retrieves the positions of all sub-chips relative to the workbench size
func get_sub_chips_positions() -> Array[Vector2]:
    var sub_chip_positions: Array[Vector2] = []
    
    for chip: Node in get_children().duplicate():
        if not chip is Chip:
            continue
        chip = chip as Chip
        sub_chip_positions.append(chip.global_position / WorkBenchComm.work_bench.get_rect().size)
    
    return sub_chip_positions

# Imports chips from an array of chip blueprints and positions them accordingly
func import_chips(chips: Array[ChipBlueprint], positions: Array[Vector2]) -> void:
    for i: int in range(chips.size()):
        var chip_position: Vector2 = Vector2.ZERO
        
        # Use provided positions if available
        if i < positions.size():
            chip_position = positions[i]
        
        add_chip(chips[i], chip_position * WorkBenchComm.work_bench.get_rect().size)

# Connects signals for chip addition and removal
func _ready() -> void:
    WorkBenchComm.chip_added.connect(add_chip)
    WorkBenchComm.chip_removed.connect(remove_chip)
