extends Node

# ======================
# PIN SELECTION & WIRE PREVIEW SYSTEM:
# ----------------------
# This class manages pin selection and wire connections in the workbench.
# It listens for pin interactions, initiates wire previews, and finalizes connections.
# ======================

# === PIN SELECTION VARIABLES ===
# Tracks the currently selected pin for wire connections.
var selected_pin: Pin = null

# ======================
# INITIALIZE PIN INTERACTIONS
# ----------------------
# Connects pin click events to ensure proper wiring operations.
# ======================
func _ready() -> void:
    InputBus.pin_clicked.connect(_on_pin_clicked)

# ======================
# HANDLE PIN SELECTION & CONNECTIONS
# ----------------------
# Determines whether to start a wire preview or finalize a connection.
# ======================
func _on_pin_clicked(pin: PinUI) -> void:
    if not get_parent().is_active:  # Ensure the workbench is active
        return

    if selected_pin:
        _selected_pin_connect(pin)  # Finalize wire connection
    else:
        _start_preview(pin)  # Start wire preview

# ======================
# FINALIZE WIRE CONNECTION
# ----------------------
# Establishes a connection between the selected pin and the target pin.
# Converts the wire preview into a permanent connection.
# ======================
func _selected_pin_connect(pin: PinUI) -> void:
    selected_pin.connect_to(pin.logic)

    # Convert wire preview into actual wire connection
    if Comm.wire_preview:
        Comm.wire_preview.finalize_connection(pin)

    # Clear selection after connection
    selected_pin = null

# ======================
# START WIRE PREVIEW
# ----------------------
# Begins a wire preview when a pin is selected.
# ======================
func _start_preview(pin: PinUI) -> void:
    selected_pin = pin.logic
    Comm.wire_preview.start_preview(pin)

# ======================
# HANDLE USER INPUT EVENTS
# ----------------------
# Responds to mouse interactions for wire creation and cancellation.
# ======================
func _input(event: InputEvent) -> void:
    if not get_parent().is_active:  # Ignore input if workbench is inactive
        return

    # Add a joint to the wire when clicking
    if event is InputEventMouseButton and event.is_pressed():
        if Comm.wire_preview:
            Comm.wire_preview.add_joint(Comm.wire_preview.next_joint)

    # Cancel the wire preview when pressing Escape
    elif event is InputEventKey and event.is_pressed():
        if event.keycode == KEY_ESCAPE:
            _cancel_preview()

# ======================
# CANCEL WIRE PREVIEW
# ----------------------
# Safely clears the wire preview and resets the selection state.
# ======================
func _cancel_preview() -> void:
    if Comm.wire_preview:
        Comm.wire_preview.cancel()

    # Reset selection state
    selected_pin = null
