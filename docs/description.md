# SimuLogic: Real-Time Digital Logic Simulator Built in Godot 4

## Overview

SimuLogic is a real-time modular digital logic simulator developed entirely in Godot 4. Created as an independent academic challenge by an undergraduate electrical engineering student, this project explores foundational principles of digital electronics and system architecture through interactive simulation.

The simulator enables users to construct and nest custom chips composed of low-level logic gates, observe real-time signal propagation, and analyze the behavior of complex digital systems. With a structured and extensible architecture, SimuLogic provides an environment for iterative design, experimentation, and learning.

The long-term vision of this project is to construct a complete digital computer within the simulation itself—demonstrating computational emergence from primitive gate-level components. This ambitious objective reflects a deep interest in systems thinking, hardware abstraction, and programming.

## Key Features

### Modular Chip Nesting

Users can design custom logic units, assign identifiers to them, and reuse or embed them within other circuits. This nesting capability allows for scalable circuit design and abstraction—essential for modeling complex systems such as CPUs.

### Event-Based Signal Propagation

To ensure efficient and stable simulation, signal changes trigger targeted events rather than global updates. Only affected components respond to pin state changes, minimizing computational overhead and eliminating signal instability or flickering.

### Frame-Based Simulation Control

Simulation advances in discrete frames. Each node receives a limited number of updates per frame, while overflow updates are deferred to subsequent cycles. This mechanism ensures consistent behavior and maintains support for feedback loops.

### Performance Tuning

Simulation speed is user-adjustable via frame parameters, offering a trade-off between responsiveness and computational throughput.

### Serialization and Persistence

All components, including custom chips and workbenches, are serialized and can be saved or restored. This enables long-term project development and the reuse of logical modules across sessions.

### Scalable Workbench System

Workbench environments support dynamic panning and zooming, providing extensive space for large-scale designs without visual constraints.

### UI/Logic Decoupling

User interface components operate independently of the simulation core. This separation improves performance, simplifies maintenance, and strengthens modularity by preventing unnecessary UI loading.

### Interactive Circuit Design

Users can wire, rewire, reposition components, and inspect pre-built chips directly on the workbench. A built-in component library enables streamlined search and insertion of logic elements.

## Architecture and Design Principles

SimuLogic is architected with a strong emphasis on modularity, maintainability, and runtime efficiency. Its internal systems are carefully structured to support scalable circuit simulation and responsive user interaction.

### Decoupled Logic and UI Systems

The simulation logic operates entirely independently of the user interface. This separation allows for optimized processing, cleaner code organization, and long-term flexibility. UI elements are loaded only when required, reducing overhead and simplifying future maintenance.

### Event-Driven Signal Propagation

State changes within the simulator are handled via an event-based system. When a pin changes state, only the necessary downstream components are notified—avoiding redundant updates and ensuring stable signal behavior. This selective propagation significantly improves performance and avoids feedback instability.

### Frame-Controlled Update Scheduling

Simulation progresses in discrete frames. Each node processes a limited number of update events per frame, with overflow events queued for subsequent cycles. This structured scheduling ensures consistent simulation pacing, even in circuits involving feedback loops or complex logic chains.

### Persistent State Logging

The simulator maintains detailed logs for all events, including pin state transitions, error messages, and timing information. This provides a robust foundation for debugging, analysis, and future extensions such as simulation replay or performance profiling.

### Intentional Code Structure

Every system within SimuLogic is modular by design. The architecture facilitates component isolation, clear interfacing, and straightforward debugging. Special attention was given to the logical separation between computational logic, rendering, and state management.

## Future Development

SimuLogic is under active development, with several enhancements planned to expand its functionality and improve simulation efficiency:

- **Bus System Integration**: Implementing multi-line buses to group related signals and enable structured communication between components. This will streamline complex logic designs and mirror real-world digital systems more effectively.

- **Dynamic Multi-Bit Pin Support**: Introducing 4-bit, 8-bit, and 16-bit pins to reduce wiring complexity and allow users to handle grouped input/output signals intuitively. This feature will simplify data manipulation and support higher-level abstraction.

- **Architecture Optimization**: Continuing refinement of the simulation engine for improved performance, scalability, and modularity. Planned upgrades include more efficient update queues, memory management strategies, and refined event dispatching.

These additions are aligned with the long-term goal of constructing a fully simulated computer within SimuLogic, emphasizing structured design, abstraction, and computational emergence.
