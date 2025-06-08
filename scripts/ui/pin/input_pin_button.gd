extends Button

# ======================
# PIN CREATION BUTTON:
# ----------------------
# This class represents a button that adds a new pin when pressed.
# It emits a signal upon pin creation and assigns relevant attributes.
# ======================

# === PIN TYPE SELECTION ===
# Defines the type of pin to be created (input or output).
@export var type: Pin.PinType

# === PIN CREATION SIGNAL ===
# Emits a signal when a new pin is instantiated.
signal add_pin(pin: Pin)

# ======================
# HANDLE BUTTON PRESS EVENT
# ----------------------
# Instantiates a new pin with predefined attributes and emits a signal.
# ======================
func _on_pressed() -> void:
	var pin: Pin = Pin.pin_logic_scene.instantiate()
	pin.name = Pin.PinType.find_key(type)  # Assign a name based on type
	pin.type = type
	pin.parent_chip = WorkBenchComm.work_bench.chip  # Set chip association
	pin.build_ui(true)  # Initialize UI representation
	
	add_pin.emit(pin)  # Notify listeners of pin creation
