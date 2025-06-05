class_name LibraryItem
extends CheckButton

# ======================
# LIBRARY ITEM COMPONENT:
# ----------------------
# This class represents an interactive library item in the selection menu.
# It manages blueprint selection and emits signals based on user interaction.
# ======================

# === PRELOADED SCENE REFERENCE ===
# Defines the base scene used for instantiating library items.
static var library_item_scene: PackedScene = preload("res://scenes/panels/library_item.tscn")

# === SIGNAL DEFINITIONS ===
# Emits events when an item is selected or deselected.
signal selected(item: LibraryItem)
signal deselected(item: LibraryItem)

# === CHIP SCHEMATIC REFERENCE ===
# Stores the schematic associated with this library item.
var schematic: ChipBlueprint

# ======================
# CREATE NEW LIBRARY ITEM
# ----------------------
# Instantiates a new library item and assigns its schematic.
# ======================
static func get_library_item(schematic_: ChipBlueprint) -> LibraryItem:
	var item: LibraryItem = library_item_scene.instantiate()
	item.schematic = schematic_
	item.text = schematic_.name
	return item 

# ======================
# HANDLE ITEM SELECTION
# ----------------------
# Detects button press events and emits corresponding signals.
# ======================
func _on_pressed() -> void:
	if button_pressed:
		selected.emit(self) 
	else:
		deselected.emit(self)
