class_name PinData
extends Resource

## Stores metadata for a pin, including its name, type, path, and state.
@export var name: String                  ## Unique name of the pin
@export var type: Pin.PinType = Pin.PinType.INPUT  ## Defines pin type (Input/Output)
@export var path: String                   ## Node path reference for the pin
@export var state: LogicUtils.State = LogicUtils.State.Z             ## Current active state of the pin