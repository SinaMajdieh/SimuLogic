class_name SevenSegment
extends Chip

# ======================
# SEVEN-SEGMENT LOGIC CHIP:
# ----------------------
# This class represents a chip that updates a seven-segment display.
# It processes input states and modifies the visual representation accordingly.
# ======================

# ======================
# UPDATE DISPLAY BASED ON INPUT
# ----------------------
# Retrieves the current input states and applies them to the UI display.
# Ensures the UI exists before attempting to update the segment colors.
# ======================
func input_updated() -> void:
	var input: Array[LogicUtils.State] = get_input_array()  # Get the current input states

	# Apply updates only if UI is present
	if ui:
		ui.seven_segment_display.update_display(input)
