extends Control

# ======================
# CHIP EXPORT UI:
# ----------------------
# This class manages chip export functionality in the workbench.
# It handles input validation, chip type selection, and export requests.
# ======================

# === UI ELEMENT REFERENCES ===
# Defines key UI components for chip exporting.
@export var line_edit: LineEdit  # Input field for chip name
@export var submit: Button  # Button for submitting export request
@export var color_pick: ColorPickerButton  # Color picker for chip type selection
@export var chip_type_options_button: OptionButton  # Dropdown menu for chip type selection

# ======================
# CHIP TYPE ENUMERATION
# ----------------------
# Defines different chip types for classification and color mapping.
# ======================
enum chip_type_options {
    LOGIC,
    MEMORY,
    PROCESSING,
    POWER,
    IO,
    SPECIAL,
    CUSTOM
}

# ======================
# CHIP TYPE COLOR MAP
# ----------------------
# Maps chip type selections to predefined colors for consistent visualization.
# ======================
var chip_type_color_map: Dictionary[int, Color] = {
    0: ChipDescription.LOGIC_CHIP_COLOR,
    1: ChipDescription.MEMORY_CHIP_COLOR,
    2: ChipDescription.PROCESSING_CHIP_COLOR,
    3: ChipDescription.POWER_CHIP_COLOR,
    4: ChipDescription.IO_CHIP_COLOR,
    5: ChipDescription.SPECIAL_CHIP_COLOR
}

# ======================
# RESET EXPORT UI
# ----------------------
# Clears input fields and resets selections to default values.
# ======================
func reset() -> void:
    line_edit.text = ""  # Clear chip name input
    chip_type_options_button.select(chip_type_options.LOGIC)  # Default to LOGIC chip type
    _on_option_button_item_selected(chip_type_options.LOGIC)  # Apply default color

# ======================
# VALIDATE EXPORT INPUT
# ----------------------
# Ensures chip name is provided and there are chips in the workbench before exporting.
# ======================
func input_is_valid() -> bool:
    if line_edit.text.is_empty():
        return false  # Ensure chip name is not empty
    
    if %WorkingBench.sub_chips_container.get_child_count() == 0:
        return false  # Ensure there are chips available for export
    
    return true

# ======================
# HANDLE EXPORT SUBMISSION
# ----------------------
# Validates input and triggers chip export.
# Closes the popup and resets fields upon success.
# ======================
func _on_submit() -> void:
    if not input_is_valid():
        Logger.log_with_time(Logger.Logs.ERRORS, "Input validation failed.")
        return
    
    WorkBenchComm.export(line_edit.text, color_pick.color)  # Export chip
    popup(false)  # Hide export UI
    reset()  # Reset input fields

# ======================
# CANCEL EXPORT REQUEST
# ----------------------
# Hides the export popup without taking action.
# ======================
func _on_cancel() -> void:
    popup(false)

# ======================
# UPDATE COLOR SELECTION
# ----------------------
# Sets predefined colors based on chip type selection.
# Enables manual color selection if "CUSTOM" is chosen.
# ======================
func _on_option_button_item_selected(index: int) -> void:
    if color_pick and chip_type_color_map.has(index):
        color_pick.color = chip_type_color_map[index]
        color_pick.disabled = true  # Lock predefined colors
    elif index == chip_type_options_button.get_item_index(chip_type_options.CUSTOM):
        color_pick.disabled = false  # Enable custom color selection

# ======================
# CONTROL EXPORT POPUP VISIBILITY
# ----------------------
# Shows or hides the export popup, adjusting workbench processing accordingly.
# ======================
func popup(active: bool) -> void:
    match active:
        true:
            visible = true
            WorkBenchComm.work_bench.process_mode = Node.PROCESS_MODE_DISABLED  # Pause workbench processing
        false:
            visible = false
            WorkBenchComm.work_bench.process_mode = Node.PROCESS_MODE_ALWAYS  # Resume workbench processing

# ======================
# INITIALIZE EXPORT SCREEN SIGNALS
# ----------------------
# Connects signals for managing export screen visibility upon startup.
# ======================
func _ready() -> void:
    Comm.export_screen.connect(popup)
