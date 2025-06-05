class_name ChipSelection
extends ScrollContainer

# ======================
# CHIP SELECTION MENU:
# ----------------------
# This class manages the available chips for selection, displaying buttons for each blueprint.
# It dynamically loads stored blueprints and registers chips for quick import into the workbench.
# ======================

# === PRELOADED CHIP BUTTON SCENE ===
# Used to instantiate buttons representing chip blueprints.
static var chip_button_scene: PackedScene = preload("res://scenes/ui/chip/chip_button.tscn")

# === CHIP STORAGE ===
# Dictionary storing available chips and their corresponding blueprints.
var chips: Dictionary[String, ChipBlueprint] = {}

# === CHIP BLUEPRINT DIRECTORY ===
# Defines the default location where chip blueprints are stored.
@export var chips_schematic_path: String = "res://blue_prints/"

# === BUTTON CONTAINER REFERENCE ===
# Holds all chip selection buttons within the scrollable menu.
@export var button_container: HBoxContainer

# ======================
# CREATE CHIP SELECTION BUTTON
# ----------------------
# Instantiates a button for the specified chip blueprint.
# The button allows users to import the chip into the workbench upon selection.
# ======================
func add_button(button_name: String) -> void:
	var button: Button = chip_button_scene.instantiate()
	button.name = button_name
	button.text = button_name
	
	# Connect button interaction to the chip import function
	button.add_chip.connect(add_chip)
	
	# Attach the button to the selection menu
	button_container.add_child(button)

# ======================
# REGISTER CHIP BLUEPRINT
# ----------------------
# Stores a chip blueprint and ensures that its button exists in the selection menu.
# Prevents duplicate buttons from being registered.
# ======================
func add_chip_button(bp: ChipBlueprint) -> void:
	chips[bp.name] = bp
	
	# Avoid adding duplicate buttons for existing chips
	if not has_node(bp.name):
		add_button(bp.name)

# ======================
# LOAD CHIP BLUEPRINTS FROM DIRECTORY
# ----------------------
# Reads chip blueprints stored in the designated directory and registers them for selection.
# Only `.tres` or `.res` files are considered valid chip blueprints.
# ======================
func read_chips(directory_path: String = chips_schematic_path) -> void:
	var dir: DirAccess = DirAccess.open(directory_path)
	if dir:
		var files: PackedStringArray = dir.get_files()
		for file_name in files:
			# Filter only blueprint files
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var resource: Resource = load("%s%s" % [directory_path, file_name]) as ChipBlueprint
				if resource:
					add_chip_button(resource)

# ======================
# INITIALIZE CHIP SELECTION MENU
# ----------------------
# Connects interaction signals for dynamically adding chips.
# Loads all available chip blueprints from storage at startup.
# ======================
func _ready() -> void:
	Comm.add_chip_to_selection_signal.connect(add_chip_button)  # Allow dynamic chip addition
	read_chips()  # Load chip blueprints from storage

# ======================
# IMPORT CHIP TO WORKBENCH
# ----------------------
# Imports the selected chip when its corresponding button is clicked.
# Transfers the blueprint data to the workbench for instantiation.
# ======================
func add_chip(button_name: String) -> void:
	if chips.has(button_name):
		Comm.import_chip(chips[button_name])

# ======================
# NAVIGATE BACK TO PREVIOUS SCREEN
# ----------------------
# Handles returning to the previous workbench view.
# ======================
func _on_back() -> void:
	WorkBenchComm.work_bench.go_back()
