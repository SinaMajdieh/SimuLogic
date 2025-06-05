class_name ChipUI
extends PanelContainer

# ======================
# CHIP UI CLASS OVERVIEW:
# ----------------------
# This class represents the visual interface of a logic chip.
# It is strictly separated from the chip’s logic layer.
# Handles UI appearance, user interactions, and linking with the logic component.
# ======================

# === PRELOADED CHIP UI SCENES ===
# These scenes are used to dynamically instantiate UI components based on chip type.
static var chip_ui_scene: PackedScene = preload("res://scenes/chip/chip_ui.tscn")
static var seven_segment_ui_scene: PackedScene = preload("res://scenes/chip/seven_segment/seven_segment_ui.tscn")  # Fixed typo

# === UI ELEMENT REFERENCES ===
# Containers for organizing pins and sub-chips visually
@export var input_container: VBoxContainer
@export var output_container: VBoxContainer
@export var sub_chip_container: VBoxContainer
@export var name_tag: Label  # Label displaying the chip name

# Reference to the chip’s logic component (UI remains separate from logic processing)
var logic: Chip

# Determines whether UI should always be visible
var force_visible: bool = false

# ======================
# APPLY BACKGROUND COLOR
# ----------------------
# This function modifies the chip's UI background color using a stylebox.
# Used to visually differentiate chips based on their category.
# ======================
func set_bg_color(color: Color) -> void:
    var stylebox: StyleBoxFlat = get("theme_override_styles/panel").duplicate()
    stylebox.bg_color = color
    set("theme_override_styles/panel", stylebox)  # Apply modified stylebox

# ======================
# INITIALIZE UI PROPERTIES
# ----------------------
# This function applies description-based properties to the UI.
# It mainly sets the background color, ensuring visual consistency.
# ======================
func init(description: ChipDescription) -> void:
    if description != null:
        set_bg_color(description.background_color)

# ======================
# BUILD CHIP UI FROM BLUEPRINT
# ----------------------
# Creates a new UI instance based on the schematic and initializes it.
# Used during chip instantiation to visually represent the logic component.
# ======================
static func build_ui(schematic: ChipBlueprint) -> ChipUI:
    var ui: ChipUI = get_chip(schematic.type)  # Instantiate UI based on chip type
    ui.init(schematic.description)  # Apply properties
    return ui

# ======================
# UI HOVER EFFECTS
# ----------------------
# Modifies chip UI transparency when hovered over.
# Helps indicate user interaction and selection visually.
# ======================
func _on_mouse_enter() -> void:
    modulate.a = 0.5  # Reduce opacity when hovered

func _on_mouse_exit() -> void:
    modulate.a = 1  # Restore opacity when no longer hovered

# ======================
# HANDLE CHIP RENAMING
# ----------------------
# This function updates the chip logic’s name when the UI name is modified.
# Ensures synchronization between UI display and underlying logic representation.
# ======================
func _on_renamed() -> void:
    if not logic:
        return
    logic.chip_name = name
    logic.name = name
    name_tag.text = logic.schematic.name  # Display updated name

# ======================
# CREATE CHIP UI INSTANCE BASED ON TYPE
# ----------------------
# Instantiates and returns the correct UI type based on the chip type.
# Seven-segment chips have specialized UI, while others use the default chip UI.
# ======================
static func get_chip(type: Chip.ChipType) -> ChipUI:
    match type:
        Chip.ChipType.SEVENSEGMENT:
            return seven_segment_ui_scene.instantiate()
        _:
            return chip_ui_scene.instantiate()

# ======================
# CLEANUP LOGIC ON TREE EXIT
# ----------------------
# Ensures the linked logic component is properly removed if UI is deleted.
# Prevents orphaned nodes and ensures consistent garbage collection.
# ======================
func _on_tree_exited() -> void:
    if logic:
        # Remove logic component from its parent before freeing it
        if logic.get_parent():
            logic.get_parent().remove_child(logic)
        logic.queue_free()
