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
    var mix_ratio: float = 0.3  # Adjust how much black is blended in

    # Blend the color components with black
    return Color(
        color.r * (1.0 - mix_ratio),  # Reduce red intensity
        color.g * (1.0 - mix_ratio),  # Reduce green intensity
        color.b * (1.0 - mix_ratio),  # Reduce blue intensity
        color.a  # Maintain original alpha transparency
    )


# ======================
# GENERATE GLOWING COLOR
# ----------------------
# This function brightens a given color by increasing saturation and brightness.
# Useful for active states or UI elements that need emphasis.
# ======================
func get_glowing_color(color: Color) -> Color:
    var glow_intensity: float = 1.5  # Adjust for stronger glow

    # Amplify the color components while clamping values to prevent overflow
    return Color(
        min(color.r * glow_intensity, 1.0),  # Boost red intensity
        min(color.g * glow_intensity, 1.0),  # Boost green intensity
        min(color.b * glow_intensity, 1.0),  # Boost blue intensity
        color.a  # Maintain original alpha transparency
    )

# ======================
# COLOR VARIATION FUNCTION:
# ----------------------
# This function modifies a base color by introducing slight hue shifts.
# It optionally generates a completely randomized color.
# ======================

func get_variation_color(base_color: Color, randomized: bool = false) -> Color:
    if randomized:
        return Color(randf(), randf(), randf())  # Generate a completely random color
    
    # Apply a slight random shift to the hue while keeping other properties unchanged
    var hue_shift: float = randf_range(-0.05, 0.05)
    var new_hue: float = fmod(base_color.h + hue_shift, 1.0)

    return Color.from_hsv(new_hue, base_color.s, base_color.v)
