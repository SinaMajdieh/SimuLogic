extends PanelBase

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
@export var color_variation: CheckBox # Checkbox to add variation to chip color
@export var message_label: Label

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
	message_label.text = ""
	message_label.visible = false
	chip_type_options_button.select(chip_type_options.LOGIC)  # Default to LOGIC chip type
	_on_option_button_item_selected(chip_type_options.LOGIC)  # Apply default color

# ======================
# VALIDATE EXPORT INPUT
# ----------------------
# Ensures chip name is provided and there are chips in the workbench before exporting.
# ======================
func input_is_valid() -> ValidationResult:
	if line_edit.text.is_empty():
		return ValidationResult.new(false, "Name required") # Ensure chip name is not empty
	
	if WorkBenchComm.work_bench.sub_chips_container.get_child_count() == 0:
		return ValidationResult.new(false, "Work bench is empty")  # Ensure there are chips available for export
	
	return ValidationResult.new(true)

# ======================
# HANDLE EXPORT SUBMISSION
# ----------------------
# Validates input and triggers chip export.
# Closes the set_open and resets fields upon success.
# ======================
func _on_submit() -> void:
	var validation: ValidationResult = input_is_valid()
	if not validation.valid:
		message_label.text = validation.message 
		message_label.visible = true
		Logger.log_with_time(Logger.Logs.ERRORS, validation.message, true)
		return
	var final_color: Color = color_pick.color
	if color_variation.button_pressed and not color_variation.disabled:
		final_color = ColorMan.get_variation_color(final_color)
	WorkBenchComm.export(line_edit.text, final_color)  # Export chip
	set_open(false)  # Hide export UI
	reset()  # Reset input fields

# ======================
# CANCEL EXPORT REQUEST
# ----------------------
# Hides the export set_open without taking action.
# ======================
func _on_cancel() -> void:
	set_open(false)

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
		color_variation.disabled = false
	elif index == chip_type_options_button.get_item_index(chip_type_options.CUSTOM):
		color_pick.disabled = false  # Enable custom color selection
		color_variation.disabled = true


# ======================
# INITIALIZE EXPORT SCREEN SIGNALS
# ----------------------
# Connects signals for managing export screen visibility upon startup.
# ======================
func _ready() -> void:
	Comm.export_screen.connect(set_open)


# ======================
# RANDOM COLOR SELECTION:
# ----------------------
# This function assigns a random color variation to the selected chip type.
# It ensures that "CUSTOM" is selected before applying a new randomized color.
# ======================

func _on_random_color_pressed() -> void:
	# Set chip type to "CUSTOM" before modifying color
	chip_type_options_button.select(chip_type_options.CUSTOM)  
	_on_option_button_item_selected(chip_type_options.CUSTOM)

	# Apply a randomized color variation
	color_pick.color = ColorMan.get_variation_color(color_pick.color, true)


func _on_chip_name_text_changed(new_text:String) -> void:
	line_edit.text = new_text.to_upper()
	line_edit.caret_column = len(new_text)
