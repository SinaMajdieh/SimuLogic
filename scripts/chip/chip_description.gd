class_name ChipDescription
extends Resource

# ======================
# CHIP METADATA RESOURCE:
# ----------------------
# This class defines properties for a chip's metadata.
# It stores visual attributes, pin positions, and wiring configurations.
# ======================

# === CHIP COLOR CONSTANTS ===
# Defines standardized colors for different chip categories.
const LOGIC_CHIP_COLOR: Color = Color("#008080")  # Logic Chips (AND, OR, XOR, etc.)
const MEMORY_CHIP_COLOR: Color = Color("#6E003A")  # Memory Chips (Registers, RAM, etc.)
const PROCESSING_CHIP_COLOR: Color = Color("#4682B4")  # Processing Units (ALUs, CPUs, etc.)
const POWER_CHIP_COLOR: Color = Color("#00FF00")  # Power-Related Chips
const IO_CHIP_COLOR: Color = Color("#C2B280")  # Input/Output Chips
const SPECIAL_CHIP_COLOR: Color = Color("#8A2BE2")  # Special Function Chips

# === CHIP APPEARANCE PROPERTIES ===
# Defines metadata related to chip visualization.
@export var background_color: Color  # Background color of the chip

# === CHIP COMPONENT POSITIONS ===
# Stores spatial data for sub-chips, wires, and pin placements.
@export var sub_chip_positions: Array[Vector2]  # Positions of sub-chips
@export var wires: Array[WireData]  # Wiring connections
@export var input_pins_positions: Array[Vector2]  # Input pin locations
@export var output_pins_positions: Array[Vector2]  # Output pin locations
