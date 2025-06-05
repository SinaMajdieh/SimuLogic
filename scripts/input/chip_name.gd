extends TextEdit

# ======================
# TEXT FIELD FOCUS MANAGEMENT:
# ----------------------
# This class handles input interactions for managing focus on a text field.
# It detects clicks outside the field and releases focus accordingly.
# ======================

# ======================
# HANDLE INPUT EVENTS
# ----------------------
# Ensures the text field retains focus unless clicked outside its boundaries.
# ======================
func _input(event: InputEvent) -> void:
    if not has_focus():
        return

    # Detect mouse clicks and check if they occur outside the text field
    if event is InputEventMouseButton and event.is_pressed():
        if not get_global_rect().has_point(event.position):
            release_focus()
