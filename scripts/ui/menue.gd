extends MenuButton

# ======================
# MENU BUTTON CONTROL:
# ----------------------
# This class manages a dropdown menu for workbench interactions.
# It dynamically adjusts size and enables/disables options based on conditions.
# ======================

# === BUTTON SIZE CONFIGURATION ===
# Defines the minimum width percentage relative to the viewport.
@export_range(0, 1) var minimum_width = 0.1

# === POPUP MENU REFERENCE ===
# Stores the popup menu instance for interaction handling.
@onready var popup: PopupMenu = get_popup()

# ======================
# INITIALIZE MENU BUTTON
# ----------------------
# Connects button interactions upon startup.
# ======================
func _ready() -> void:
    popup.id_pressed.connect(_on_pressed)

# ======================
# MENU ITEM ENUMERATION
# ----------------------
# Defines available options within the dropdown menu.
# ======================
enum items {CREATE, LIBRARY, IO}

# ======================
# HANDLE MENU SELECTION
# ----------------------
# Triggers relevant workbench functions when an item is selected.
# ======================
func _on_pressed(id: int) -> void:
    match id:
        items.CREATE:
            Comm.set_export_screen()
        items.IO:
            Comm.set_io_screen_screen()
        items.LIBRARY:
            Comm.set_library_panel()

# ======================
# ADJUST BUTTON SIZE DYNAMICALLY
# ----------------------
# Updates the button's minimum width based on the viewport size.
# ======================
func _on_resized() -> void:
    custom_minimum_size.x = get_viewport().size.x * minimum_width

# ======================
# TOGGLE MENU ITEM AVAILABILITY
# ----------------------
# Disables or enables the "CREATE" option based on workbench state.
# ======================
func _process(_delta: float) -> void:
    if WorkBenchComm.work_bench.chip_stack.size() > 0:
        popup.set_item_disabled(popup.get_item_index(items.CREATE), true)
    else:
        popup.set_item_disabled(popup.get_item_index(items.CREATE), false)
