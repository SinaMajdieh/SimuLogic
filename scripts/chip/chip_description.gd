class_name ChipDescription
extends Resource

const LOGIC_CHIP_COLOR :Color = Color("#008080")  ## Logic Chips (AND, OR, XOR, etc.) 
const MEMORY_CHIP_COLOR :Color = Color("#6E003A")  ## Memory Chips (Registers, RAM, etc.)
const PROCESSING_CHIP_COLOR:Color = Color("#4682B4")  ## Processing Units (ALUs, CPUs, etc.)
const POWER_CHIP_COLOR:Color = Color("#00FF00")  ## Power-Related Chips
const IO_CHIP_COLOR:Color = Color("#C2B280")  ## Input/Output Chips
const SPECIAL_CHIP_COLOR:Color = Color("#8A2BE2")  ## Special Function Chips

## Stores metadata about a chip, including its visual appearance.
@export var background_color: Color  ## Background color of the chip
@export var sub_chip_positions:Array[Vector2]
@export var wires:Array[WireData]
