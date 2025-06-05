extends Node

# ======================
# COLOR MODIFICATION UTILITIES:
# ----------------------
# This utility script provides functions to adjust a given color's appearance.
# - `get_muted_color()`: Reduces saturation and brightness for a dimmer look.
# - `get_glowing_color()`: Enhances saturation and brightness for an illuminated effect.
# ======================

# ======================
# GENERATE MUTED COLOR
# ----------------------
# This function dims a given color by reducing saturation and brightness.
# Useful for inactive states or UI elements that need a subdued appearance.
# ======================
func get_muted_color(color: Color) -> Color:
    var h: float = color.h  # Extract hue
    var s: float = color.s  # Extract saturation
    var v: float = color.v  # Extract brightness

    s *= 0.4  # Reduce saturation (less intensity)
    v *= 0.5  # Reduce brightness (darker look)

    return Color.from_hsv(h, s, v, color.a)  # Return modified color

# ======================
# GENERATE GLOWING COLOR
# ----------------------
# This function brightens a given color by increasing saturation and brightness.
# Useful for active states or UI elements that need emphasis.
# ======================
func get_glowing_color(color: Color) -> Color:
    var h: float = color.h  # Extract hue
    var s: float = color.s  # Extract saturation
    var v: float = color.v  # Extract brightness

    s = clamp(s * 1.2, 0, 1)  # Increase saturation (more vivid)
    v = clamp(v * 1.5, 0, 1)  # Increase brightness (stronger glow)

    return Color.from_hsv(h, s, v, color.a)  # Return modified color
