class_name SevenSegmentDisplay
extends CenterContainer

# ======================
# SEVEN-SEGMENT DISPLAY COMPONENT:
# ----------------------
# This class represents a UI element for a seven-segment display.
# It visually updates segment colors based on input states.
# ======================

# === PRELOADED DISPLAY SCENE ===
# Used to instantiate a new seven-segment display dynamically.
const display_scene: PackedScene = preload("res://scenes/chip/seven_segment/seven_segment_display.tscn")

# === SEGMENT COLORS ===
# Defines colors for active (ON) and inactive (OFF) states.
@export var off_color: Color
@export var on_color: Color

# === SEGMENT UI ELEMENTS ===
# Stores an array of display segments for color updates.
@export var display_segments: Array[ColorRect]

# ======================
# CREATE NEW DISPLAY INSTANCE
# ----------------------
# Instantiates and returns a new SevenSegmentDisplay object.
# Used for dynamically generating display components in the UI.
# ======================
static func new_display() -> SevenSegmentDisplay:
    var display: SevenSegmentDisplay = display_scene.instantiate()
    return display

# ======================
# UPDATE SEGMENT COLORS
# ----------------------
# Modifies the display segments based on the provided input states.
# Each segment changes to ON or OFF color based on its corresponding boolean value.
# ======================
func update_display(segments: Array[LogicUtils.State]) -> void:
    # Validate that the input size matches the number of display segments
    if segments.size() != display_segments.size():
        Logger.log_with_time(Logger.Logs.ERRORS, "Seven segment expected %d inputs but received %d" % [display_segments.size(), segments.size()], true)
        return
    
    # Apply colors based on active/inactive states
    for i: int in range(display_segments.size()):
        display_segments[i].color = on_color if LogicUtils.is_high(segments[i]) else off_color
