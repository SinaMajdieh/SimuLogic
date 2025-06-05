extends Control

# ======================
# CHIP MANAGEMENT SYSTEM:
# ----------------------
# This class handles chip creation, removal, and schematic retrieval for the workbench.
# It facilitates importing chip blueprints and positioning chips dynamically.
# ======================

# ======================
# IMPORT CHIP BLUEPRINT
# ----------------------
# Instantiates a chip using its blueprint and adds it to the workbench.
# Initializes the chip logic upon creation.
# ======================
func import_chip(bp: ChipBlueprint) -> void:
    var sub_chip_node: Chip = Chip.chip_logic_scene.instantiate()
    add_child(sub_chip_node)
    
    # Apply blueprint data and initialize logic
    sub_chip_node.synthesize(bp, 1)

# ======================
# RETRIEVE CHIP SCHEMATICS
# ----------------------
# Collects schematic data from all chips currently present in the workbench.
# Returns an array of blueprints for serialization or re-use.
# ======================
func get_chips_schematics() -> Array[ChipBlueprint]:
    var schematics: Array[ChipBlueprint] = []
    
    for chip: Node in get_children():
        if not chip is ChipUI:
            continue
        chip = chip as ChipUI  # Explicitly cast to ChipUI type
        schematics.append(chip.logic.schematic)  # Store schematic data
    
    return schematics

# ======================
# ADD CHIP TO WORKBENCH
# ----------------------
# Instantiates a chip, assigns its schematic, and positions it in the workbench.
# The `global` parameter determines whether position is absolute or relative.
# ======================
func add_chip(schematic: ChipBlueprint, chip_position: Vector2, global: bool = true) -> void:
    var chip: Chip = Chip.get_chip(schematic.type)
    chip.synthesize(schematic, 1)
    add_child(chip.ui)
    chip.ui.name = schematic.name

    # Set position based on global or relative placement
    if global:
        chip.ui.global_position = chip_position
    else:
        chip.ui.position = chip_position
    
    Sim.add_chip(chip)

# ======================
# REMOVE SPECIFIC CHIP
# ----------------------
# Disconnects and removes a chip from the workbench.
# Ensures cleanup before freeing memory.
# ======================
func remove_chip(chip: ChipUI) -> void:
    if not chip:
        return
    
    # Verify chip exists before removal
    if has_node(String(chip.name)):
        chip.logic.disconnect_chip()  # Disconnect all associated links
        remove_child(chip)
        chip.queue_free()  # Free memory

# ======================
# REMOVE ALL CHIPS
# ----------------------
# Clears all chips from the workbench, ensuring proper cleanup.
# ======================
func remove_all() -> void:
    for chip: Node in get_children():
        if chip is ChipUI:
            remove_chip(chip)

# ======================
# GET SUB-CHIP POSITIONS
# ----------------------
# Retrieves positions of all sub-chips relative to the workbench.
# Used for blueprint serialization and UI adjustments.
# ======================
func get_sub_chips_positions() -> Array[Vector2]:
    var sub_chip_positions: Array[Vector2] = []
    
    for chip: Node in get_children().duplicate():
        if not chip is ChipUI:
            continue
        chip = chip as ChipUI
        sub_chip_positions.append(chip.position)
    
    return sub_chip_positions

# ======================
# IMPORT MULTIPLE CHIPS
# ----------------------
# Instantiates and positions multiple chips from an array of blueprints.
# Uses provided positions if available, otherwise defaults to (0,0).
# ======================
func import_chips(chips: Array[ChipBlueprint], positions: Array[Vector2]) -> void:
    for i: int in range(chips.size()):
        var chip_position: Vector2 = Vector2.ZERO
        
        # Use provided positions when available
        if i < positions.size():
            chip_position = positions[i]
        
        add_chip(chips[i], chip_position, false)

# ======================
# INITIALIZE CHIP SIGNALS
# ----------------------
# Connects signals for chip addition and removal.
# Ensures dynamic interaction between workbench and chips.
# ======================
func _ready() -> void:
    WorkBenchComm.chip_added.connect(add_chip)
    WorkBenchComm.chip_removed.connect(remove_chip)
