extends PanelContainer

# Constants for chip separation adjustments
const MAX_SEPARATION_VALUE: int = 50
const MIN_SEPARATION_VALUE: int = 0
const SEPARATION_STEP: int = 5

# Container for holding chips dynamically
@export var chips_container: VBoxContainer

# Instantiates a new chip and synthesizes it from a blueprint
func add_chip(bp: ChipBlueprint) -> void:
    var chip_node: Chip = Chip.chip_scene.instantiate()
    chips_container.add_child(chip_node)
    chip_node.synthesize(bp, 1)

# Closes the container if visible
func close() -> void:
    if visible:
        visible = false

# Opens the container if hidden
func open() -> void:
    if not visible:
        visible = true

# Updates position based on mouse movement if chips are present
func _process(_delta: float) -> void:
    if chips_container.get_child_count() == 0:
        close()
    else:
        open()
    global_position = get_global_mouse_position()

# Places chips in the workbench at the clicked position
func place_chips(_clicked_position: Vector2) -> void:
    for chip in chips_container.get_children():
        if chip is Chip:
            var chip_position: Vector2 = chip.global_position
            WorkBenchComm.add_chip(chip.schematic, chip_position)

# Removes all chips from the container and frees them
func remove_all_chips() -> void:
    for chip: Node in chips_container.get_children():
        if chip is Chip:
            chips_container.remove_child(chip)
            chip.queue_free()

# Handles user input actions for scrolling and exiting
func _input(_event: InputEvent) -> void:
    if Input.is_action_just_pressed("ui_scroll_up"):
        var separation: int = chips_container.get_theme_constant("separation")
        separation = min(separation + SEPARATION_STEP, MAX_SEPARATION_VALUE)
        chips_container.add_theme_constant_override("separation", separation)

    elif Input.is_action_just_pressed("ui_scroll_down"):
        var separation: int = chips_container.get_theme_constant("separation")
        separation = max(MIN_SEPARATION_VALUE, separation - SEPARATION_STEP)
        chips_container.add_theme_constant_override("separation", separation)

    elif Input.is_action_just_pressed("ui_exit"):
        remove_all_chips()

# Connects interaction signals upon initialization
func _ready() -> void:
    InputBus.work_bench_clicked.connect(place_chips)
    Comm.import_chip_signal.connect(add_chip)
