extends Node

var update_frame: int = -1 

## Signals for handling chip interactions and exporting workbench data.
signal add_chip_to_selection_signal(schematic: ChipBlueprint)
signal import_chip_signal(bp: ChipBlueprint)
signal export_screen(active:bool)
signal io_screen(active:bool)
signal sim_frame_changed(lenght:float)

## Emits a signal to add a chip schematic to the selection.
func add_chip_to_selection(schematic: ChipBlueprint) -> void:
	add_chip_to_selection_signal.emit(schematic)

func set_export_screen(active:bool=true) -> void:
	export_screen.emit(active)

func set_io_screen_screen(active:bool=true) -> void:
	io_screen.emit(active)

func set_sim_frame(lenght:float) -> void:
	sim_frame_changed.emit(lenght)

## Emits a signal to import a chip blueprint.
func import_chip(bp: ChipBlueprint) -> void:
	import_chip_signal.emit(bp)
