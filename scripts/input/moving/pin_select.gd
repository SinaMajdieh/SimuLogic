extends Node

# ======================
# PIN INTERACTION HANDLER:
# ----------------------
# This class manages user interactions with pins.
# It listens for pin clicks and toggles the state of valid input pins.
# ======================

# ======================
# HANDLE PIN CLICK EVENTS
# ----------------------
# Toggles the state of the clicked pin if it is a valid input pin.
# Ignores interactions for output pins or inactive parent nodes.
# ======================
func _on_pin_clicked(pin: PinUI) -> void:
    if not pin is InteractablePin:
        return 
    if not get_parent().is_active or pin.logic.pin_type == Pin.PinType.OUTPUT:
        return
    
    pin.logic.state = not pin.logic.state  # Toggle pin state

# ======================
# INITIALIZE PIN INTERACTION
# ----------------------
# Connects the pin click event upon startup, ensuring proper signal handling.
# ======================
func _ready() -> void:
    InputBus.pin_clicked.connect(_on_pin_clicked)
