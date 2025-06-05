extends Node

# ======================
# PIN & CHIP MANAGEMENT SYSTEM:
# ----------------------
# This class organizes input pins, output pins, and chips within their respective containers.
# It supports dynamically adding components to maintain a structured hierarchy.
# ======================

# === CONTAINER REFERENCES ===
# Defines storage locations for inputs, outputs, and chips.
@export var input_container: Node  # Stores input pins
@export var output_container: Node  # Stores output pins
@export var chip_container: Node  # Stores chips

# ======================
# ADD INPUT OR OUTPUT PIN
# ----------------------
# Adds a pin to its designated container based on type.
# ======================
func add_io_pin(pin: Pin) -> void:
    match pin.pin_type:
        Pin.PinType.INPUT:
            input_container.add_child(pin)
        Pin.PinType.OUTPUT:
            output_container.add_child(pin)

# ======================
# ADD CHIP TO CONTAINER
# ----------------------
# Registers a chip within the appropriate chip storage.
# ======================
func add_chip(chip: Chip) -> void:
    chip_container.add_child(chip)
