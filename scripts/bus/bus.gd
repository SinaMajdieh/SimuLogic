class_name Bus
extends Node

var pins: Array[Pin] = []
var bus_width: int = 4

var ui: InteractableBusUI

# You could use INPUT/OUTPUT for the whole bus, or infer from pins[0]
var type: Pin.PinType

# Create N pins
func build_bus(parent_chip: Chip, bus_type_: Pin.PinType, width: int = 4) -> void:
	bus_width = width
	self.type = bus_type_
	for i in width:
		var pin = Pin.new()
		pin.name = "bit_%d" % i
		pin.type = bus_type_
		pin.parent_chip = parent_chip
		pins.append(pin)
		pin.pin_state_updated.connect(bus_state_updated)
		add_child(pin)

func bus_state_updated() -> void:
	if ui:
		ui.update_gui()

# Get full state
func get_state() -> Array[LogicUtils.State]:
	var states: Array[LogicUtils.State] = []
	for pin: Pin in pins:
		states.append(pin.state)
	return states

# Set full state
func set_state(states: Array[LogicUtils.State]) -> void:
	for i in min(states.size(), pins.size()):
		pins[i].change_state(states[i])

# UI logic could optionally wrap all bit UIs in one control
func build_ui() -> void:
	if ui:
		return
	ui = InteractableBusUI.build_ui(self)

func synthesize(bus_data: BusData, parent_chip: Chip) -> void:
	bus_width = bus_data.bus_width
	type = bus_data.type
	build_bus(parent_chip, type, bus_width)

func serialize() -> BusData:
	var bus_data: BusData = BusData.new()
	bus_data.name = name
	bus_data.type = type
	bus_data.bus_width = bus_width
	return bus_data
