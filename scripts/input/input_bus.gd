class_name InputBusManager
extends Node

## Signals for handling key input events.
signal pin_clicked(pin: Pin)
signal chip_clicked(chip: Chip, click_position: Vector2)
signal work_bench_clicked(click_position: Vector2)

signal wire_clicked(wire: Chip, clicked_position:Vector2)
signal new_wire(wire: Wire)

## Emits a signal when a pin is clicked.
func notify_pin_clicked(pin: Pin) -> void:
	# print_debug("Pin clicked: %s" % pin.name)
	pin_clicked.emit(pin)

## Emits a signal when a chip is clicked, providing the click position.
func notify_chip_clicked(chip: Chip, click_position: Vector2) -> void:
	# print_debug("Chip clicked: %s at %s " % [chip.name, click_position])
	chip_clicked.emit(chip, click_position)

## Emits a signal when a wire is clicked.
func notify_wire_clicked(wire: Wire, clicked_position:Vector2) -> void:
	wire_clicked.emit(wire, clicked_position)


## Emits a signal when the working bench is clicked.
func notify_work_bench_clicked(click_position: Vector2) -> void:
	work_bench_clicked.emit(click_position)

## Emits a signal when a new wire is created.
func notify_new_wire(wire: Wire) -> void:
	#print_debug("New wire created")
	new_wire.emit(wire)
