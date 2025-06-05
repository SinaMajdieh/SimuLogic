extends Node2D

# ======================
# GRID DRAWING SYSTEM:
# ----------------------
# This class renders a dynamic grid within the viewport.
# The grid updates based on size and spacing parameters.
# ======================

# === GRID CONFIGURATION ===
# Defines grid spacing and color properties.
@export var grid_spacing := 32  # Distance between grid lines
@export var grid_color := Color(0.3, 0.3, 0.3, 0.5)  # Gray, semi-transparent

# ======================
# RENDER GRID LINES
# ----------------------
# Draws the grid dynamically based on the viewport size.
# ======================
func _draw() -> void:
    var size: Vector2 = get_viewport_rect().size
    
    # Draw vertical grid lines
    for x in range(0, int(size.x), grid_spacing):
        draw_line(Vector2(x, 0), Vector2(x, size.y), grid_color, 1)

    # Draw horizontal grid lines
    for y in range(0, int(size.y), grid_spacing):
        draw_line(Vector2(0, y), Vector2(size.x, y), grid_color, 1)

# ======================
# FORCE GRID REDRAW
# ----------------------
# Ensures the grid updates dynamically each frame.
# ======================
func _process(_delta: float) -> void:
    queue_redraw()
