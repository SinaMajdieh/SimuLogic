extends Node2D

# ======================
# RIGHT-CLICK MENU HANDLER:
# ----------------------
# This class manages a popup menu triggered by right-click input.
# It detects mouse events and positions the menu dynamically.
# ======================

# === MENU REFERENCE ===
# Stores the popup menu instance for interaction.
@onready var menue: PopupMenu = $PopupMenu  # (Potential typo: Should this be "menu"?)

# ======================
# PROCESS MOUSE INPUT
# ----------------------
# Detects right-click events and triggers the menu display.
# ======================
func process_input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.is_pressed():
        if event.button_index == MOUSE_BUTTON_RIGHT:
            show_menue()

# ======================
# DISPLAY CONTEXT MENU
# ----------------------
# Positions and displays the popup menu at the cursor location.
# ======================
func show_menue() -> void:
    var last_mouse_postion = get_global_mouse_position()
    menue.popup(Rect2(
        last_mouse_postion.x, 
        last_mouse_postion.y,
        menue.size.x,
        menue.size.y
    ))
