extends Node

## Stores the selected pin and wire preview instance.
var selected_pin: Pin = null
var wire_preview: WirePreview = null

## Initializes connections.
func _ready() -> void:
	InputBus.pin_clicked.connect(_on_pin_clicked)

## Handles pin selection and connection logic.
func _on_pin_clicked(pin: Pin) -> void:
	if not get_parent().is_active:
		return

	if selected_pin:
		_selected_pin_connect(pin)
	else:
		_start_preview(pin)

## Connects selected pin to target pin and finalizes wire preview.
func _selected_pin_connect(pin: Pin) -> void:
	selected_pin.connect_to(pin)
	#print_debug("Connected %s -> %s" % [selected_pin.name, pin.name])

	if wire_preview:
		wire_preview.finalize_connection(pin)  # Convert preview line to permanent connection

	selected_pin = null
	wire_preview = null

## Starts a new wire preview for the selected pin.
func _start_preview(pin: Pin) -> void:
	selected_pin = pin
	wire_preview = WirePreview.wire_preview_scene.instantiate()
	add_child(wire_preview)
	wire_preview.start_preview(pin)

## Handles input events for wire interactions.
func _input(event: InputEvent) -> void:
	if not get_parent().is_active:
		return

	if event is InputEventMouseButton and event.is_pressed():
		if wire_preview:
			wire_preview.add_joint(wire_preview.next_joint)

	elif event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_ESCAPE:
			_cancel_preview()

## Cancels the wire preview safely.
func _cancel_preview() -> void:
	if wire_preview:
		wire_preview.cancel()
	wire_preview = null
	selected_pin = null
