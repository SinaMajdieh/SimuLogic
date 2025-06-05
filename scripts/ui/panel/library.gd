extends PanelBase

# ======================
# CHIP LIBRARY SYSTEM:
# ----------------------
# This class manages library items for chip selection.
# It handles loading, selection, interaction, and viewing functionalities.
# ======================

# === LIBRARY ITEM CONTAINERS ===
# Organizes chips into built-in and custom categories.
@export var built_in: VBoxContainer  # Stores built-in chips
@export var custom: VBoxContainer  # Stores custom chips

# === SELECTION TRACKING ===
# Stores the currently selected library item.
@export var selected: LibraryItem = null

# ======================
# HANDLE CHIP SELECTION
# ----------------------
# Selects a library item and updates UI state accordingly.
# ======================
func select(item: LibraryItem) -> void:
	if not item:
		return
	if selected:
		selected.button_pressed = false
	selected = item
	item.button_pressed = true
	set_buttons_enable(true)

# ======================
# HANDLE CHIP DESELECTION
# ----------------------
# Deselects the currently active item and resets UI controls.
# ======================
func deselect(item: LibraryItem) -> void:
	if item != selected:
		return
	selected.button_pressed = false
	selected = null
	set_buttons_enable(false)

# ======================
# ENABLE/DISABLE UI BUTTONS
# ----------------------
# Toggles button availability based on selection state.
# ======================
func set_buttons_enable(enable: bool) -> void:
	$Center/Background/Items/Buttons/Add.disabled = not enable
	$Center/Background/Items/Buttons/View.disabled = not enable

# ======================
# LOAD CHIP LIBRARY
# ----------------------
# Scans a directory for stored chip blueprints and adds them to the UI.
# ======================
func load_library(directory_path: String = Comm.chips_schematic_path) -> void:
	var dir: DirAccess = DirAccess.open(directory_path)
	if dir:
		var files: PackedStringArray = dir.get_files()
		for file_name in files:
			# Filter only blueprint files
			if file_name.ends_with(".tres") or file_name.ends_with(".res"):
				var resource: Resource = load("%s%s" % [directory_path, file_name]) as ChipBlueprint
				if resource:
					add_item(resource)

# ======================
# ADD CHIP TO LIBRARY
# ----------------------
# Creates a new library item and assigns it to the appropriate category.
# ======================
func add_item(schematic: ChipBlueprint) -> void:
	var item: LibraryItem = LibraryItem.get_library_item(schematic)
	item.selected.connect(select)
	item.deselected.connect(deselect)

	if schematic.type == Chip.ChipType.COMPOSIT:
		custom.add_child(item)
	else:
		built_in.add_child(item)
	
	item.name = schematic.name

# ======================
# IMPORT SELECTED CHIP
# ----------------------
# Imports a chip from the library into the workbench.
# ======================
func add() -> void:
	if not selected:
		return
	Comm.import_chip(selected.schematic)

# ======================
# INITIALIZE LIBRARY SYSTEM
# ----------------------
# Loads chip data and connects UI signals upon startup.
# ======================
func _ready() -> void:
	load_library()
	Comm.library_panel.connect(set_open)

# ======================
# CLOSE LIBRARY PANEL
# ----------------------
# Deselects an active item and hides the library interface.
# ======================
func _on_close_pressed() -> void:
	if selected:
		deselect(selected)
	set_open(false)

# ======================
# VIEW SELECTED CHIP
# ----------------------
# Navigates to the selected chip's workbench view.
# ======================
func _on_view_pressed() -> void:
	if not selected:
		return

	if WorkBenchComm.work_bench.chip_stack.size() > 0:
		WorkBenchComm.work_bench.go_to_workbench(0)
	
	WorkBenchComm.work_bench.import(selected.schematic)
	_on_close_pressed()
