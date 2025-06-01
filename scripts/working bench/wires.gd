class_name WireGUI
extends Node2D

## Stores a list of active wires in the scene.
var wires: Array[Wire] = []

## Adds a new wire to the GUI and stores a reference.
func add_wire(wire: Wire) -> void:
	wires.append(wire)
	add_child(wire)

## Connects to wire creation signals upon initialization.
func _ready() -> void:
	InputBus.new_wire.connect(add_wire)
