class_name Pin
extends Node

# ======================
# PIN LOGIC COMPONENT:
# ----------------------
# This class manages pin logic within the simulation.
# It defines pin types, tracks connections, and processes state changes dynamically.
# ======================

# === PRELOADED PIN SCENES ===
# Defines scenes used for instantiating pin logic components.
static var pin_logic_scene: PackedScene = preload("res://scenes/pin/pin_logic.tscn")
static var interactable_pin_logic_scene: PackedScene = preload("res://scenes/pin/work_bench_pin.tscn")

# === PIN UI REFERENCE ===
# Stores the UI representation of the pin.
var ui: PinUI

# === PIN STATE TRACKING ===
# Tracks frame updates and queued state changes.
var last_update_frame: int = -1
var queued_value: Array[LogicUtils.State] = []

# === PIN TYPE ENUMERATION ===
# Defines available pin types.
enum PinType {INPUT, OUTPUT}

# === CHIP REFERENCE ===
# Stores the parent chip this pin belongs to.
var parent_chip: Chip

# === CONNECTION TRACKING ===
# Lists pins that are connected and those providing state updates.
var connected_to: Array[Pin] = []
var receive_state_from: Array[Pin] = []

# ======================
# PIN TYPE MANAGEMENT
# ----------------------
# Sets and retrieves the pin type (input or output).
# ======================
var type: PinType:
	set(new_type):
		type = new_type

# ======================
# PIN STATE MANAGEMENT
# ----------------------
# Stores and updates pin state, triggering UI changes upon modification.
# ======================

var state: LogicUtils.State = LogicUtils.State.Z:
	set(new_state):
		if new_state == state:
			return
		state = new_state
		if ui:
			ui.update_button_gui()
		pin_state_updated.emit()

# ======================
# DETERMINE PIN TYPE
# ----------------------
# Checks whether the pin is an input or output.
# ======================
func is_input_pin() -> bool:
	return type == PinType.INPUT

func is_output_pin() -> bool:
	return type == PinType.OUTPUT

# ======================
# SIGNAL DEFINITIONS
# ----------------------
# Defines event signals for pin state changes.
# ======================
signal pin_state_updated()

# ======================
# UPDATE PIN STATE
# ----------------------
# Modifies pin state and handles queued updates.
# ======================
func change_state(new_state: LogicUtils.State) -> void:
	if Comm.update_frame != last_update_frame:
		Logger.log(Logger.Logs.PIN_STATE, "[%s] %s->%s : %s" % [Comm.update_frame, parent_chip.name, name, LogicUtils.State.find_key(new_state)])
		last_update_frame = Comm.update_frame
		queued_value.clear()
		state = new_state
	else:
		queued_value.push_front(new_state)
		add_to_group("queued")

# ======================
# RETRIEVE STATE FROM SOURCES
# ----------------------
# Gathers pin states from connected sources.
# ======================
func receive_state() -> LogicUtils.State:
	for pin in receive_state_from:
		if not pin:
			receive_state_from.erase(pin)
		if not LogicUtils.is_high_impedance(pin.state):
			return pin.state
	return LogicUtils.State.Z

# ======================
# HANDLE PIN STATE UPDATES
# ----------------------
# Changes pin state based on incoming signals.
# ======================
func update_pin_state() -> void:
	change_state(receive_state())

# ======================
# PROCESS QUEUED STATE UPDATES
# ----------------------
# Handles state updates as frames advance.
# ======================
func queued_update() -> void:
	remove_from_group("queued")
	if queued_value.is_empty():
		return
	change_state(queued_value[0])

# ======================
# ESTABLISH PIN CONNECTIONS
# ----------------------
# Links the pin to a target pin for state updates.
# Updates UI color when applicable.
# ======================
func connect_to(target_pin: Pin) -> void:
	connected_to.append(target_pin)
	pin_state_updated.connect(target_pin.update_pin_state)
	target_pin.receive_state_from.append(self)

	if ui and target_pin.ui:
		if target_pin.type == PinType.INPUT or target_pin.ui is InteractablePin:
			target_pin.ui.pin_color = ui.pin_color

	target_pin.update_pin_state()
	Logger.log(Logger.Logs.CONNECTIONS, "%s --> %s" % [name, target_pin.name])

# ======================
# DISCONNECT FROM TARGET PIN
# ----------------------
# Removes connections between pins and updates state tracking.
# ======================
func disconnect_from(target_pin: Pin) -> void:
	if target_pin:
		Logger.log(Logger.Logs.CONNECTIONS, "Disconnecting %s from %s" % [name, target_pin.name])
		if target_pin.pin_state_updated.is_connected(update_pin_state):
			target_pin.pin_state_updated.disconnect(update_pin_state)
		receive_state_from.erase(target_pin)
		target_pin.connected_to.erase(self)
		update_pin_state()

# ======================
# CLEAR ALL PIN CONNECTIONS
# ----------------------
# Removes all established connections safely.
# ======================
func clear_connections() -> void:
	for pin in connected_to.duplicate():
		pin.disconnect_from(self)
	for pin in receive_state_from.duplicate():
		disconnect_from(pin)

	connected_to.clear()
	receive_state_from.clear()

# ======================
# BUILD PIN UI COMPONENT
# ----------------------
# Instantiates the UI representation of the pin.
# ======================
func build_ui(interactable: bool = false) -> void:
	if ui:
		return
	ui = InteractablePin.build_ui(self) if interactable else PinUI.build_ui(self)
	ui.logic = self

# ======================
# APPLY PIN BLUEPRINT DATA
# ----------------------
# Configures pin attributes based on a `PinData` object.
# ======================
func synthesize(pin_data: PinData) -> void:
	name = pin_data.name
	type = pin_data.type

# ======================
# SERIALIZE PIN DATA
# ----------------------
# Converts the pin's attributes into a `PinData` object.
# ======================
func serialize() -> PinData:
	var pin_data := PinData.new()
	pin_data.name = name
	pin_data.type = type
	pin_data.state = state
	return pin_data
