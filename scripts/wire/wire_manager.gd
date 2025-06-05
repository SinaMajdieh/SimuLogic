extends Node2D

# ======================
# WIRE MANAGEMENT SYSTEM:
# ----------------------
# This class tracks and manages all wire connections in the workbench.
# It handles wire creation, removal, serialization, and importing.
# ======================

# === ACTIVE WIRE STORAGE ===
# Stores all active wires within the simulation.
var wires: Array[Wire] = []
var last_wire_layer: int = -1  # Tracks layering order for rendering priority.

# ======================
# ADD WIRE TO WORKBENCH
# ----------------------
# Registers a new wire within the simulation, assigning it a layer index.
# ======================
func add_wire(wire: Wire) -> void:
    last_wire_layer += 1
    wire.layer_index = last_wire_layer
    wires.append(wire)  # Store the wire reference
    add_child(wire)  # Attach wire to the scene

# ======================
# REMOVE ALL WIRES
# ----------------------
# Clears all wire connections from the workbench.
# ======================
func remove_all() -> void:
    for wire in wires:
        wire.queue_free()  # Free memory for each wire
    wires.clear()  # Clear wire reference list
    last_wire_layer = -1  # Reset layer tracking

# ======================
# REMOVE SPECIFIC WIRE
# ----------------------
# Disconnects and removes a wire from the workbench.
# ======================
func remove_wire(wire: Wire) -> void:
    if not wire:
        return

    # Disconnect wire from connected pins before removal
    if wire.target_pin and wire.source_pin:
        wire.target_pin.disconnect_from(wire.source_pin)

    # Remove wire from tracked list
    if wires.has(wire):
        wires.remove_at(wires.find(wire))
    
    # Ensure the wire exists before removing it from the scene
    if has_node(String(wire.name)):
        remove_child(wire)
    
    # Free memory for the wire instance
    wire.queue_free()
    last_wire_layer -= 1

# ======================
# RETRIEVE WIRE CONNECTIONS
# ----------------------
# Returns a dictionary mapping source pin paths to connected target pins.
# ======================
func get_wire_connections(path_from: Node) -> Dictionary[String, Array]:
    var connections: Dictionary[String, Array] = {}
    
    for wire in wires:
        var source_path: String = path_from.get_path_to(wire.source_pin)
        var target_path: String = path_from.get_path_to(wire.target_pin)
        
        # Store connections dynamically
        connections[source_path] = connections.get(source_path, []) + [target_path]
    
    return connections

# ======================
# SERIALIZE WIRE DATA
# ----------------------
# Extracts wire data into an array for saving or exporting.
# ======================
func get_wires_data() -> Array[WireData]:
    var wires_data: Array[WireData]
    for wire: Wire in wires:
        if not wire:
            continue
        var wire_data: WireData = wire.get_wire_data()
        wires_data.append(wire_data)
    return wires_data

# ======================
# CONNECT PINS VIA WIRE
# ----------------------
# Establishes a connection between source and target pins via wire linking.
# ======================
func connect_wire_pins(wire: Wire) -> void:
    if not wire.target_pin or not wire.source_pin:
        Logger.log_with_time(Logger.Logs.ERRORS, "Wire's source pin or target pin not found while connecting the wire", true)
        return
    wire.source_pin.connect_to(wire.target_pin)

# ======================
# IMPORT WIRES FROM DATA
# ----------------------
# Loads wire connections from serialized data and reconstructs them in the simulation.
# ======================
func import_wires(wires_data: Array[WireData], connect_wires: bool = true) -> void:
    for wire_data: WireData in wires_data:
        var source_pin: Pin = Sim.get_node(wire_data.source_pin)
        var target_pin: Pin = Sim.get_node(wire_data.target_pin)

        if not source_pin or not target_pin:
            Logger.log_with_time(Logger.Logs.ERRORS, "Wire's source pin or target pin not found", true)
            continue
        
        # Create wire instance
        var wire: Wire = Wire.new_wire(source_pin, target_pin, wire_data.points)

        if connect_wires:
            connect_wire_pins(wire)

        add_wire(wire)

# ======================
# INITIALIZE WIRE SIGNALS
# ----------------------
# Connects signals for wire addition and removal upon startup.
# ======================
func _ready() -> void:
    WorkBenchComm.wire_added.connect(add_wire)
    WorkBenchComm.wire_removed.connect(remove_wire)
