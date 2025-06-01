# Digital Logic Simulator - Code Documentation

## Overview

This document provides a **detailed breakdown** of the scripts used in the project, explaining their **functionality, purpose, and interactions** with other components.

---

## **1. Chip System**

### `Chip.gd`

#### **Purpose**:

Represents a chip with **logical functionality**, managing input pins, output pins, and processing states.

#### **Key Functions**:

- `input_updated(_source_pin: Pin) -> void` → Updates output state based on the chip's logic type.
- `set_bg_color(color: Color) -> void` → Changes the chip’s background color.
- `synthesize(blueprint: ChipBlueprint, render_level: int) -> void` → Instantiates a chip using a blueprint, creating pins and sub-chips.

#### **Connections**:

- Listens for **pin state updates** to process logic dynamically.
- Uses `ChipBlueprint.gd` for **structural configuration**.

---

### `ChipBlueprint.gd`

#### **Purpose**:

Stores the **layout and logic properties** for a chip, including **pins, sub-chips, and wiring**.

#### **Key Functions**:

- Acts as a **resource file (`.tres`)** used for saving and loading chip configurations.
- Holds **connections dictionary**, mapping pin states across chips.

---

## **2. Pin System**

### `Pin.gd`

#### **Purpose**:

Represents **an individual pin** in a chip, handling **state changes** and **connections** to other pins.

#### **Key Functions**:

- `change_state(new_state: bool) -> void` → Toggles pin state.
- `connect_to(target_pin: Pin) -> void` → Links pins to form wire connections.
- `clear_connections() -> void` → Removes all existing wire connections.

#### **Connections**:

- Emits signals when **state changes** to notify connected components.
- Works with `Wire.gd` for **visual connections** between chips.

---

### `PinData.gd`

#### **Purpose**:

Stores **metadata about a pin**, used in **blueprint serialization**.

#### **Key Fields**:

- `name: String` → Pin identifier.
- `type: Pin.PinType` → Defines whether it's an input or output.
- `state: bool` → Stores the pin’s logical value.

---

## **3. Wire System**

### `Wire.gd`

#### **Purpose**:

Handles **connections between pins**, updating logic states dynamically.

#### **Key Functions**:

- `change_state(new_state: bool) -> void` → Sets wire state based on connected pins.
- `constrain_line() -> void` → Adjusts wire shape for better visualization.

#### **Connections**:

- Listens to **pin state updates**.
- Works alongside `WirePreview.gd` for **previews before wire finalization**.

---

### `WirePreview.gd`

#### **Purpose**:

Displays a **visual preview** of a wire before connection is finalized.

#### **Key Functions**:

- `start_preview(pin: Pin) -> void` → Begins wire creation from a pin.
- `finalize_connection(pin: Pin) -> void` → Converts preview into a real wire.

---

### `WireGUI.gd`

#### **Purpose**:

Manages **active wires** in the scene.

#### **Connections**:

- Listens to `InputBus.new_wire` signals to track wire creation dynamically.

---

## **4. Workbench System**

### `WorkingBench.gd`

#### **Purpose**:

Acts as the **central workspace**, allowing users to **place chips, connect wires, and export circuits**.

#### **Key Functions**:

- `generate_blueprint(chip_name: String) -> ChipBlueprint` → Creates a blueprint of the current workbench layout.
- `export(chip_name: String) -> void` → Saves the workbench state.
- `empty_work_bench() -> void` → Clears all components.

#### **Connections**:

- Handles **click input** to interact with components dynamically.
- Uses `Arch.gd` for **saving/loading chip blueprints**.

---

### `Arch.gd`

#### **Purpose**:

Manages **saving and loading chip blueprints** as `.tres` files.

#### **Key Functions**:

- `save_blueprint(bp: ChipBlueprint, file_name: String) -> void` → Stores blueprint in the filesystem.

---

## **5. User Interaction System**

### `InputManager.gd`

#### **Purpose**:

Switches between **Wiring Mode** and **Moving Mode**, handling user interactions.

#### **Key Functions**:

- `toggle_mode(keycode: Key) -> void` → Activates wiring or moving mode.
- `update_active_mode(mode: Mode) -> void` → Applies the selected mode to child nodes.

#### **Connections**:

- Works with `InputMode.gd` for **event-based control**.
- Receives key input from `_input(event: InputEvent)`.

---

### `MovingMode.gd`

#### **Purpose**:

Handles **dragging chips** across the workbench.

#### **Key Functions**:

- `_input(event: InputEvent) -> void` → Detects mouse input for dragging.
- `activate() -> void` → Enables moving mode.

---

## **6. Event Bus System**

### `InputBus.gd`

#### **Purpose**:

Centralizes **event handling** for clicks and interactions.

#### **Key Signals**:

- `pin_clicked(pin: Pin)`
- `chip_clicked(chip: Chip, click_position: Vector2)`
- `new_wire(wire: Wire)`

---

### `InputBusManager.gd`

#### **Purpose**:

Manages different input signals, including **chip selection, pin clicks, and wire creation**.

#### **Key Functions**:

- `notify_pin_clicked(pin: Pin) -> void` → Emits pin click signals.
- `notify_new_wire(wire: Wire) -> void` → Notifies when a wire is created.

---

## **Conclusion**

This project is structured for **modularity, scalability, and user interaction**. Each system plays a role in:

- **Creating and manipulating logic circuits**.
- **Handling input and signals dynamically**.
- **Providing a visual and interactive simulation environment**.

---

## **Future Extensions**

- **Undo/Redo functionality**.
- **Multi-chip workbench capabilities**.
- **Improved wire animations and visual effects**.
- **Blueprint sharing via online storage**.

---

This should provide **a comprehensive explanation** of how all scripts interact! Would you like additional details on **specific algorithms or optimizations**?
