extends ChipUI

# ======================
# SEVEN-SEGMENT DISPLAY UI:
# ----------------------
# This class represents the UI component for a seven-segment display.
# It ensures proper visualization and maintains visibility when initialized.
# ======================

# === DISPLAY COMPONENT ===
# UI reference for the seven-segment display element.
@export var seven_segment_display: SevenSegmentDisplay

# ======================
# INITIALIZE DISPLAY UI
# ----------------------
# Ensures the display remains visible when the chip is instantiated.
# This overrides default visibility settings to ensure proper rendering.
# ======================
func _ready() -> void:
    force_visible = true
