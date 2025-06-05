extends MenuButton

# Defines a minimum width percentage relative to the viewport
@export_range(0, 1) var minimum_width = 0.1

# Connects button interactions at initialization
func _ready() -> void:
    get_popup().id_pressed.connect(_on_pressed)

# Enumeration for button menu options
enum items {CREATE, IO}

# Handles workbench export when a menu item is selected
func _on_pressed(id: int) -> void:
    match id:
        items.CREATE:
            Comm.set_export_screen()
        items.IO:
            Comm.set_io_screen_screen()

# Adjusts the button's minimum size based on viewport width
func _on_resized() -> void:
    custom_minimum_size.x = get_viewport().size.x * minimum_width
