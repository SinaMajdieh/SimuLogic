class_name InputBusManager
extends Node

# ======================
# INPUT EVENT SIGNAL DISPATCHER:
# ----------------------
# This class serves as the central hub for input event management.
# It listens for interactions with pins, chips, and wires, emitting signals accordingly.
# ======================

# ======================
# SIGNAL DEFINITIONS
# ----------------------
# Defines communication signals triggered by user interactions.
# These signals notify other components when an event occurs.
# ======================

# Signals for pin interactions
signal pin_clicked(pin: PinUI)  # Triggered when a pin is clicked
signal pin_body_clicked(pin: PinUI, click_position: Vector2)  # Triggered when a pin body is clicked

# Signals for chip interactions
signal chip_clicked(chip: ChipUI, click_position: Vector2)  # Triggered when a chip is clicked
signal work_bench_clicked(click_position: Vector2)  # Triggered when the workbench is clicked

# Signals for wire interactions
signal wire_clicked(wire: Wire, clicked_position: Vector2)  # Triggered when a wire is clicked
signal new_wire(wire: Wire)  # Triggered when a new wire is created

# ======================
# PIN EVENT DISPATCHING
# ----------------------
# Emits signals when a pin is clicked, notifying connected components.
# ======================

func notify_pin_clicked(pin: PinUI) -> void:
    pin_clicked.emit(pin)

func notify_pin_body_clicked(pin: PinUI, click_position: Vector2) -> void:
    pin_body_clicked.emit(pin, click_position)

# ======================
# CHIP EVENT DISPATCHING
# ----------------------
# Emits signals when a chip is clicked, forwarding its position.
# ======================

func notify_chip_clicked(chip: ChipUI, click_position: Vector2) -> void:
    chip_clicked.emit(chip, click_position)

# ======================
# WIRE EVENT DISPATCHING
# ----------------------
# Emits signals when a wire is clicked or a new wire is created.
# ======================

func notify_wire_clicked(wire: Wire, clicked_position: Vector2) -> void:
    wire_clicked.emit(wire, clicked_position)

func notify_new_wire(wire: Wire) -> void:
    new_wire.emit(wire)

# ======================
# WORKBENCH EVENT DISPATCHING
# ----------------------
# Emits signals when the workbench is clicked.
# ======================

func notify_work_bench_clicked(click_position: Vector2) -> void:
    work_bench_clicked.emit(click_position)
