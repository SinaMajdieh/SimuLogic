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
@export var search_bar: LineEdit

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

func load_library() -> void:
	clear_children(built_in)
	clear_children(custom)
	var schematics:  Array[ChipBlueprint] = Arch.load_schematics()
	for schematic in schematics:
		add_item(schematic)

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

# ======================
# TOGGLE SETTINGS SCREEN VISIBILITY
# ----------------------
# Opens or closes the simulation settings panel.
# Resets values when displayed.
# ======================
func set_open(open: bool) -> void:
	if open:
		load_library()
		search_bar.text = ""
	visible = open

# ======================
# NODE CHILDREN REMOVAL:
# ----------------------
# This function removes all child nodes from the specified parent node.
# It ensures proper cleanup and memory management by freeing each child.
# ======================

func clear_children(node: Node) -> void:
	for child: Node in node.get_children():
		node.remove_child(child)  # Detach child from parent node
		child.queue_free()  # Free memory associated with the child

# ======================
# ITEM SEARCH SYSTEM:
# ----------------------
# This function filters and displays items based on a user query.
# It hides non-matching items while ensuring selected items are properly deselected.
# ======================

func search(query: String) -> void:
	query = query.to_lower()  # Normalize input for case-insensitive search

	# Iterate over built-in items
	for item: Node in built_in.get_children():
		if not query in item.name.to_lower():
			item.hide()
			if selected == item:
				deselect(selected)
		else:
			item.show()

	# Iterate over custom items
	for item: Node in custom.get_children():
		if not query in item.name.to_lower():
			item.hide()
			if selected == item:
				deselect(selected)
		else:
			item.show()

# ======================
# SHOW ALL ITEMS
# ----------------------
# Ensures all library items are visible.
# ======================
func show_all_items() -> void:
	for item: Node in built_in.get_children():
		item.show()
	for item: Node in custom.get_children():
		item.show()

# ======================
# HANDLE SEARCH BAR INPUT
# ----------------------
# Filters items based on search input or shows all if the field is empty.
# ======================
func _on_search_bar_text_changed(new_text: String) -> void:
	if new_text.is_empty():
		show_all_items()
	else:
		search(new_text)
