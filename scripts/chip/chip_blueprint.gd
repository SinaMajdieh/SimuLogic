class_name ChipBlueprint
extends Resource

## Represents a blueprint for a chip, storing key attributes for construction.
@export var name: String                                ## Name of the chip
@export var type: Chip.ChipType                         ## Type classification of the chip
@export var input_pins: Array[PinData]                  ## List of input pins
@export var output_pins: Array[PinData]                 ## List of output pins
@export var sub_chips: Array[ChipBlueprint]             ## Nested sub-chips within this chip
@export var connections: Dictionary[String, Array]      ## Mapping of connections by pin identifier
@export var description: ChipDescription                ## Detailed description of the chip
