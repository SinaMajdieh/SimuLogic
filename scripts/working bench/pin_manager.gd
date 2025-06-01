extends VBoxContainer

# Defines the pin type for the container, defaulting to INPUT
@export var type: Pin.PinType = Pin.PinType.INPUT

# Retrieves schematic data for all pins in the container
func get_pin_schematics() -> Array[PinData]:
    var pin_schematics: Array[PinData] = []
    
    # Iterate through child nodes and collect pin schematics
    for pin in get_children():
        if pin is Pin:
            pin_schematics.append(pin.generate_data())
    
    return pin_schematics

# Clears all connections from pins
func clear_connections() -> void:
    for pin in get_children().duplicate():  # Ensure safe removal while iterating
        if pin is Pin:
            pin.clear_connections()

# Instantiates and adds a new pin with the given name
func add_pin(pin_name: String) -> void:
    var interactable_pin := Pin.interactable_pin_scene.instantiate()
    interactable_pin.name = pin_name
    interactable_pin.pin_type = type
    
    # Assign parent chip reference dynamically
    interactable_pin.parent_chip = get_parent().get_parent().chip
    
    # Add the new pin to the container
    add_child(interactable_pin)

# Adds multiple pins, assigning names automatically if needed
func add_pins(count: int, names: Array[String] = []) -> void:
    for i in range(count):
        var pin_name: String = ""
        
        # Use provided names or generate defaults based on type
        if i < names.size():
            pin_name = names[i]
        else:
            var prefix: String = Pin.PinType.find_key(type)
            pin_name = "%s-%d" % [prefix, i]
        
        add_pin(pin_name)

# Retrieves a list of all pin names
func get_pin_names() -> Array[String]:
    var names: Array[String] = []
    
    # Iterate through pins and collect their names
    for pin: Node in get_children():
        if pin is Pin:
            names.append(pin.name)
    
    return names

# Removes a specific pin and clears its connections
func remove_pin(pin: InteractablePin) -> void:
    pin.clear_connections()
    remove_child(pin)
    pin.queue_free()

# Removes all pins from the container
func remove_pins() -> void:
    for pin: Node in get_children():
        if pin is Pin:
            remove_pin(pin)

# Adjusts the number of pins while preserving existing names where possible
func change_pins(amount: int) -> void:
    var names: Array[String] = get_pin_names()
    remove_pins()
    add_pins(amount, names)

# Imports pins from a PinData array
func import_pins(pins_data: Array[PinData]) -> void:
    var pin_names: Array[String] = []
    
    # Extract pin names from PinData objects
    for pin_data in pins_data:
        pin_names.append(pin_data.name)
    
    # Add pins based on imported data
    add_pins(pins_data.size(), pin_names)
