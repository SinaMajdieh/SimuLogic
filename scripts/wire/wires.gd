class_name WireGUI
extends Node2D

# ======================
# WIRE GUI MANAGER:
# ----------------------
# This class manages the visual representation of wires in the scene.
# It tracks active wires and handles their addition dynamically.
# ======================

# === ACTIVE WIRE STORAGE ===
# Stores all active wires within the GUI.
var wires: Array[Wire] = []

# ======================
# ADD WIRE TO GUI
# ----------------------
# Registers a new wire in the scene and stores its reference.
# ======================
func add_wire(wire: Wire) -> void:
    wires.append(wire)
    add_child(wire)

# ======================
# INITIALIZE WIRE HANDLING
# ----------------------
# Connects signals to detect and process new wire creation.
# ======================
func _ready() -> void:
    InputBus.new_wire.connect(add_wire)
