extends VBoxContainer

# ======================
# CHIP INTERACTION HANDLER:
# ----------------------
# This class manages mouse input interactions for chip UI elements.
# It detects clicks on the chip container and forwards events accordingly.
# ======================

# === CHIP REFERENCE ===
# Retrieves the associated Chip node from its parent structure.
@onready var chip: ChipUI = get_parent().get_parent()

# ======================
# HANDLE USER INPUT EVENTS
# ----------------------
# Processes mouse interactions, detecting left and right clicks on chip UI.
# Sends notifications when a chip is clicked for further processing.
# ======================
func _input(event: InputEvent) -> void:
    # Ensure the chip reference is valid before processing input
    if chip == null:
        return

    # Detect left-click and check if it occurred within this node's boundaries
    if Input.is_action_just_pressed("ui_left_click"):
        if get_global_rect().has_point(event.position):
            InputBus.notify_chip_clicked(chip, event.position)  # Notify chip selection

    # Detect right-click and verify position within this node
    elif Input.is_action_just_pressed("ui_right_click"):
        if get_global_rect().has_point(event.position):
            WorkBenchComm.import(chip.logic.schematic)  # Trigger chip import
