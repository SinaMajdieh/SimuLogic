class_name Pin
extends MarginContainer

## Preloaded pin scene for dynamic instantiation.
static var pin_scene: PackedScene = preload("res://scenes/pin/pin.tscn")
static var interactable_pin_scene: PackedScene = preload("res://scenes/pin/work_bench_pin.tscn")

@export var input_manager: Node
@export var button_gui:CheckButton

var last_update_frame: int = -1
var queued_value = []

## Enum defining pin types.
enum PinType {INPUT, OUTPUT}

## References the chip this pin belongs to.
var parent_chip: Chip

## Tracks connected pins and sources that update this pin.
var connected_to: Array[Pin] = []
var receive_state_from: Array[Pin] = []

## Pin type definition with setter.
var pin_type: PinType:
	set(new_type):
		pin_type = new_type

## Current state of the pin.
var state: bool = false:
	set(new_state):
		if new_state == state:
			return
		state = new_state
		button_gui.button_pressed = new_state  # Ensures visual sync with CheckButton state
		pin_state_updated.emit()

## Signal emitted when pin state changes.
signal pin_state_updated()

## Changes the state of the pin.
func change_state(new_state: bool) -> void:
	#print("update request for pin %s at %d" % [parent_chip.name+" "+name, Comm.update_frame])
	if Comm.update_frame != last_update_frame:
			#print("%s updated last at %d and now wanna update at %d" % [parent_chip.name+" "+name, last_update_frame, Comm.update_frame])
			Logger.log(Logger.Logs.PIN_STATE, "%s->%s updated to %s at frame %d" % [parent_chip.name, name, state, Comm.update_frame])
			last_update_frame = Comm.update_frame
			if not queued_value.is_empty():
				#print("clearing %s update queue" % [parent_chip.name+" "+name])
				Logger.log(Logger.Logs.PIN_STATE, "%s->%s updated queued to %s at frame %d" % [parent_chip.name, name, state, Comm.update_frame])
				queued_value = []
			state = new_state
	else:
		queued_value.push_front(new_state)
		#print("%s queud %s" % [parent_chip.name+" "+name, queued_value])
		add_to_group("queued")

## Get pin state of the pins it can receive state from
func receive_state() -> bool:
	for pin in receive_state_from:
		if not pin:
			receive_state_from.erase(pin)
		if pin.state:
			return true
	return false

## Updates pin state based on an external source.
func update_pin_state() -> void:
	change_state(receive_state())

func queued_update()-> void:
	remove_from_group("queued")
	if queued_value.is_empty():
		return
	#print("%s queued update applied %s" % [parent_chip.name+" "+name, queued_value[0]])
	change_state(queued_value[0])

## Establishes a connection between this pin and a target pin.
func connect_to(target_pin: Pin) -> void:
	connected_to.append(target_pin)
	pin_state_updated.connect(target_pin.update_pin_state)
	target_pin.receive_state_from.append(self)
	target_pin.update_pin_state()
	Logger.log(Logger.Logs.CONNECTIONS, "connecting %s to %s" % [name, target_pin.name])

## Disconnects from a specified target pin.
func disconnect_from(target_pin: Pin) -> void:
	if target_pin:
		Logger.log(Logger.Logs.CONNECTIONS, "Disconnecting %s from %s" % [name, target_pin.name])
		if target_pin.pin_state_updated.is_connected(update_pin_state):
			target_pin.pin_state_updated.disconnect(update_pin_state)
		receive_state_from.erase(target_pin)
		target_pin.connected_to.erase(self)
		update_pin_state()

## Clears all existing connections.
func clear_connections() -> void:
	for pin in connected_to.duplicate():
		pin.disconnect_from(self)

	for pin in receive_state_from.duplicate():
		disconnect_from(pin)

	connected_to.clear()
	receive_state_from.clear()

## Populates pin attributes based on a `PinData` instance.
func synthesize(pin_data: PinData) -> void:
	name = pin_data.name
	pin_type = pin_data.type


## Generates a `PinData` object from the pin’s current state.
func generate_data() -> PinData:
	var pin_data := PinData.new()
	pin_data.name = name
	pin_data.type = pin_type
	pin_data.state = state
	return pin_data

## Handles click interactions.
func _on_pressed() -> void:
	button_gui.button_pressed = not button_gui.button_pressed  # Prevent button toggling unless the pin state actually changes
	InputBus.notify_pin_clicked(self)


## Displays tooltip when hovered.
func _on_mouse_entered() -> void:
	pass
	#ToolTip.show_tooltip(name)

## Hides tooltip when mouse exits.
func _on_mouse_exited() -> void:
	pass
	#ToolTip.hide_tooltip()

func _on_renamed() -> void:
	button_gui.tooltip_text = name

func _ready() -> void:
	button_gui.tooltip_text = name

func get_center() -> Vector2:
	return global_position + size / 2
