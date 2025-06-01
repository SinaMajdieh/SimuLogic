extends Control

# UI elements for chip exporting
@export var line_edit: LineEdit  # Input field for chip name
@export var submit: Button  # Button for submitting export request
@export var color_pick: ColorPickerButton  # Color picker for chip type selection
@export var chip_type_options_button: OptionButton  # Dropdown menu for chip type selection

# Enum defining different chip types
enum chip_type_options {
    LOGIC,
    MEMORY,
    PROCESSING,
    POWER,
    IO,
    SPECIAL,
    CUSTOM
}

# Maps chip type selections to predefined colors
var chip_type_color_map: Dictionary[int, Color] = {
    0: ChipDescription.LOGIC_CHIP_COLOR,
    1: ChipDescription.MEMORY_CHIP_COLOR,
    2: ChipDescription.PROCESSING_CHIP_COLOR,
    3: ChipDescription.POWER_CHIP_COLOR,
    4: ChipDescription.IO_CHIP_COLOR,
    5: ChipDescription.SPECIAL_CHIP_COLOR
}

# Resets UI input fields to default values
func reset() -> void:
    line_edit.text = ""  # Clear chip name input
    chip_type_options_button.select(chip_type_options.LOGIC)  # Default to LOGIC chip type
    _on_option_button_item_selected(chip_type_options.LOGIC)  # Apply default color

# Validates input before exporting
func input_is_valid() -> bool:
    if line_edit.text.is_empty():
        return false  # Ensure chip name is not empty
    
    # Ensure there are chips in the workbench before exporting
    if %WorkingBench.sub_chips_container.get_child_count() == 0:
        return false
    
    return true

# Handles submission of chip export request
func _on_submit() -> void:
    # Ensure input validation passes
    if not input_is_valid():
        Logger.log_with_time(Logger.Logs.ERRORS, "Input validation failed.")
        return
    
    # Trigger chip export with selected name and color
    WorkBenchComm.export(line_edit.text, color_pick.color)
    
    # Close popup and reset inputs
    popup(false)
    reset()

# Cancels export and closes popup
func _on_cancel() -> void:
    popup(false)

# Updates color selection based on chip type
func _on_option_button_item_selected(index: int) -> void:
    # Apply predefined color if chip type exists in the map
    if color_pick and chip_type_color_map.has(index):
        color_pick.color = chip_type_color_map[index]
        color_pick.disabled = true
    # Enable manual color selection if "CUSTOM" is selected
    elif index == chip_type_options_button.get_item_index(chip_type_options.CUSTOM):
        color_pick.disabled = false

# Controls popup visibility
func popup(active: bool) -> void:
    match active:
        true:
            visible = true  # Show popup
            %WorkingBench.process_mode = Node.PROCESS_MODE_DISABLED  # Pause workbench processing
        false:
            visible = false  # Hide popup
            %WorkingBench.process_mode = Node.PROCESS_MODE_ALWAYS  # Resume workbench processing

# Connects signals for managing export screen visibility
func _ready() -> void:
    Comm.export_screen.connect(popup)
