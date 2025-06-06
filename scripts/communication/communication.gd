extends Node

# ======================
# SIMULATION MANAGEMENT:
# ----------------------
# This class manages simulation properties, chip interactions, and signal emissions.
# It tracks timing parameters and facilitates communication within the workbench environment.
# ======================

# === FRAME TIMING PARAMETERS ===
# Tracks simulation frame updates and gate delays.
var update_frame: int = -1  # Stores the current simulation frame index.
var gate_delay: int = 1  # Defines processing delay for logic gates.

# === GLOBAL WIREFRAME PREVIEW ===
# Stores a reference to the wire preview component for dynamic visualization.
var wire_preview: WirePreview

# ======================
# SIGNAL DEFINITIONS
# ----------------------
# Defines communication signals for chip interactions, workbench exports, and frame updates.
# ======================

signal import_chip_signal(bp: ChipBlueprint)  # Imports a chip blueprint.
signal export_screen(active: bool)  # Controls workbench export screen visibility.
signal io_screen(active: bool)  # Toggles the input/output configuration screen.
signal library_panel(active: bool)  # Toggles the library screen. 
signal sim_frame_changed(length: float)  # Updates simulation timing settings.


# ======================
# TOGGLE EXPORT SCREEN
# ----------------------
# Emits a signal to open or close the chip export interface.
# Default state is active when called without parameters.
# ======================
func set_export_screen(active: bool = true) -> void:
    export_screen.emit(active)

# ======================
# TOGGLE INPUT/OUTPUT CONFIGURATION SCREEN
# ----------------------
# Emits a signal to control the visibility of the IO settings interface.
# Default state is active when called without parameters.
# ======================
func set_io_screen_screen(active: bool = true) -> void:
    io_screen.emit(active)

# ======================
# TOGGLE LIBRARY SCREEN
# ----------------------
# Emits a signal to control the visibility of the library interface.
# Default state is active when called without parameters.
# ======================
func set_library_panel(active: bool = true) -> void:
    library_panel.emit(active)

# ======================
# UPDATE SIMULATION FRAME SETTINGS
# ----------------------
# Emits a signal to modify simulation timing based on the provided frame length.
# ======================
func set_sim_frame(length: float) -> void:
    sim_frame_changed.emit(length)

# ======================
# IMPORT CHIP BLUEPRINT
# ----------------------
# Emits a signal to instantiate and load a chip from its blueprint.
# ======================
func import_chip(bp: ChipBlueprint) -> void:
    import_chip_signal.emit(bp)
