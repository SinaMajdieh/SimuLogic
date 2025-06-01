extends Node2D

# Stores all active wires in the workbench
var wires: Array[Wire] = []

# Adds a wire to the workbench and tracks it
func add_wire(wire: Wire) -> void:
    wires.append(wire)  # Store the wire reference
    add_child(wire)  # Add the wire to the scene

# Removes all wires from the workbench
func remove_all() -> void:
    for wire in wires.duplicate():
        wire.queue_free()  # Free memory for each wire
    wires.clear()  # Clear the stored wire references

# Removes a specific wire and disconnects it from pins
func remove_wire(wire: Wire) -> void:
    if not wire:
        return
    
    # Disconnect the wire from its connected pins
    if wire.target_pin and wire.source_pin:
        wire.target_pin.disconnect_from(wire.source_pin)

    # Remove the wire from the tracked list
    if wires.has(wire):
        wires.remove_at(wires.find(wire))
    
    # Ensure the wire exists before removing it from the scene
    if has_node(String(wire.name)):
        remove_child(wire)
    
    # Free memory for the wire instance
    wire.queue_free()

# Retrieves a dictionary of wire connections from a given node's perspective
func get_wire_connections(path_from: Node) -> Dictionary[String, Array]:
    var connections: Dictionary[String, Array] = {}
    
    # Iterate over wires to record connections
    for wire in wires:
        var source_path: String = path_from.get_path_to(wire.source_pin)
        var target_path: String = path_from.get_path_to(wire.target_pin)
        
        # Append the target pin path to the source pin's connection list
        connections[source_path] = connections.get(source_path, []) + [target_path]
    
    return connections

# Serialize the wire
func get_wires_data() -> Array[WireData]:
    var wires_data:Array[WireData]
    for wire:Wire in wires:
        if not wire:
            continue
        var wire_data:WireData = wire.get_wire_data()
        wires_data.append(wire_data)
    return wires_data

# Connects the source pin of the wire to its target pin
func connect_wire_pins(wire:Wire) -> void:
    if not wire.target_pin or not wire.source_pin:
        Logger.log_with_time(Logger.Logs.ERRORS, "Wire's source pin or target pin not found while connecting the wire", true)
        return
    wire.source_pin.connect_to(wire.target_pin)

# Import wires from a WireData Array
func import_wires(wires_data:Array[WireData], connect_wires:bool = true) -> void:
    for wire_data:WireData in wires_data:
        var source_pin:Pin = WorkBenchComm.work_bench.get_node(wire_data.source_pin)
        var target_pin:Pin = WorkBenchComm.work_bench.get_node(wire_data.target_pin)
        if not source_pin or not target_pin:
            Logger.log_with_time(Logger.Logs.ERRORS, "Wire's source pin or target pin not found", true)
            continue
        var wire:Wire = Wire.new_wire(source_pin, target_pin, Wire.denormalize_wire_points(wire_data.points, WorkBenchComm.work_bench.get_rect().size))
        if connect_wires:
            connect_wire_pins(wire)
        add_wire(wire)

# Connects signals for wire addition and removal when the workbench is ready
func _ready() -> void:
    WorkBenchComm.wire_added.connect(add_wire)
    WorkBenchComm.wire_removed.connect(remove_wire)
