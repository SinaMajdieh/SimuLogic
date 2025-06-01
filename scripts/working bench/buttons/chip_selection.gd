class_name ChipSelection
extends GridContainer

# Preloaded scene for chip selection buttons
static var chip_button_scene: PackedScene = preload("res://scenes/chip/chip_button.tscn")

# Dictionary storing available chips and their blueprints
var chips: Dictionary[String, ChipBlueprint] = {}

# Path to stored chip blueprints
@export var chips_schematic_path: String = "res://blue_prints/"

# Creates and adds a button for the specified chip
func add_button(button_name: String) -> void:
    var button: Button = chip_button_scene.instantiate()
    button.name = button_name
    button.text = button_name
    
    # Connects the button's signal to trigger chip import on click
    button.add_chip.connect(add_chip)
    
    # Adds the button to the grid container
    add_child(button)

# Registers a chip blueprint and ensures a corresponding button exists
func add_chip_button(bp: ChipBlueprint) -> void:
    chips[bp.name] = bp
    
    # Prevent duplicate buttons from being added
    if not has_node(bp.name):
        add_button(bp.name)

# Reads chip blueprints from the specified directory and loads them into the selection
func read_chips(directory_path: String = chips_schematic_path) -> void:
    var dir: DirAccess = DirAccess.open(directory_path)
    if dir:
        # Retrieve all files within the directory
        var files: PackedStringArray = dir.get_files()
        for file_name in files:
            # Ensure only `.tres` or `.res` resource files are loaded
            if file_name.ends_with(".tres") or file_name.ends_with(".res"):
                var resource: Resource = load("%s%s" % [directory_path, file_name]) as ChipBlueprint
                if resource:
                    add_chip_button(resource)

# Initializes connections and loads available chip blueprints on startup
func _ready() -> void:
    # Connects an external signal to dynamically add chip buttons
    Comm.add_chip_to_selection_signal.connect(add_chip_button)
    
    # Reads and registers chip blueprints from storage
    read_chips()

# Imports a chip when its corresponding button is clicked
func add_chip(button_name: String) -> void:
    if chips.has(button_name):
        Comm.import_chip(chips[button_name])


func _on_back() -> void:
    WorkBenchComm.work_bench.go_back()
