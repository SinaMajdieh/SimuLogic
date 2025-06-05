class_name MovingMode
extends InputMode

# ======================
# CHIP MOVEMENT MODE:
# ----------------------
# This class manages chip movement interactions by forwarding drag events to the movement handler.
# It allows activation and deactivation of movement mode.
# ======================

# === CHIP MOVEMENT HANDLER ===
# References the chip movement logic to process dragging interactions.
@onready var chip_movement: Node = $Chip

# ======================
# PROCESS INPUT EVENTS
# ----------------------
# Detects user interactions and forwards drag events to the chip movement system.
# ======================
func _input(event: InputEvent) -> void:
    chip_movement.process_drag(event)

# ======================
# ACTIVATE MOVEMENT MODE
# ----------------------
# Enables movement mode, allowing chips to be dragged.
# ======================
func activate() -> void:
    is_active = true

# ======================
# DEACTIVATE MOVEMENT MODE
# ----------------------
# Disables movement mode and clears dragging state.
# ======================
func deactivate() -> void:
    chip_movement.dragged_item = null
    is_active = false
