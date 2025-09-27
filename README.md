# SimuLogic: Real-Time Digital Logic Simulator in Godot 4

![Signal Propagation](docs/assets/signal_propagation.gif)  
![Nested Chip View](docs/assets/nested_chip_logic_units.gif)  

## Introduction

SimuLogic is a fully real‑time, gate‑level digital logic simulator built entirely within the Godot Engine. Designed for engineers, educators, and enthusiasts, it allows the construction of complex computational systems from the simplest possible primitives — individual logic gates — while visualizing signal propagation as it happens.

The simulator combines an event‑driven architecture with a clean separation between logic execution and user interface rendering, enabling it to handle large, nested chip hierarchies with millisecond‑level precision. Every advanced circuit — from adders and decoders to memory units and display modules — is built organically inside SimuLogic from base components, reflecting a self‑sustaining design philosophy with no reliance on hardcoded behavior.

Whether used for hands‑on learning, rapid prototyping, or exploring unconventional approaches to system simulation, SimuLogic delivers on three core principles:

- **Clarity** — modular, readable architecture rooted in clean code practices.
- **Performance** — optimized event‑based signal handling for scalability and responsiveness.
- **Extensibility** — users can encapsulate their designs into reusable “chips,” share them, and integrate them into larger projects with ease.

SimuLogic demonstrates how computation can emerge from first principles, serving as an intuitive bridge between the abstract theory of digital systems and their tangible, dynamic behavior.

## Features

- **Real‑Time Gate‑Level Simulation** — Every circuit in SimuLogic runs at millisecond‑resolution, with event‑based signal propagation ensuring responsive performance and visual clarity. Only components affected by state changes update per frame, minimizing overhead and enabling large‑scale designs.

- **Self‑Hosted Component Architecture** — All advanced modules (adders, memory units, multi‑digit displays) are built inside the simulator from primitive gates and pins, showcasing its extensibility without relying on pre‑baked logic.

- **Interactive Circuit Design** — Drag‑and‑drop chips, wires, and pins directly on the workbench; customize colors, names, input/output configuration, and orientation. Nested chip inspection allows layer‑by‑layer exploration and debugging.

- **Reusable Chip Library** — Save and encapsulate any circuit as a reusable “chip,” fully portable between projects. Integrated search enables quick access to built‑in, user‑defined, and imported modules.

- **Performance‑Optimized Simulation Core** — Deferred signal overflow handling ensures stable execution under heavy load and deep nesting. Event‑driven updates keep simulation speed consistent regardless of complexity.

- **Persistence & Sharing** — Full serialization of chips, circuits, and workbench setups, with export/import for sharing and collaborative reviews.

- **Advanced Debugging Tools** — Frame‑by‑frame logging of connections, pin states, errors, and user interactions via a multi‑channel logging system, enabling precise behavior analysis.

- **Educational Sandbox** — Freedom to experiment with concepts like race conditions, clocked vs. unclocked memory, and multi‑chip cooperation. Systems emerge naturally through trial and discovery rather than rigid instructions.

- **Roadmap‑Ready Extensibility** — Architected for future integrations such as RISC‑style CPUs, multi‑bit pins, bus systems, ALUs, and community‑driven chip libraries — all designed to align with the current modular philosophy.

## Architecture Overview

SimuLogic’s codebase is organized into modular execution and representation layers, ensuring clear separation between **signal processing**, **visual components**, and **support tooling**. This design allows large, nested circuits to run efficiently while remaining easy to extend or debug.

### Core Components

- **Logs (`/logs`)** — Multi‑channel logging system tracking simulation events, user interactions, and errors.  
  - `connections.log` — Records wiring changes and connection states.  
  - `error.log` — Captures runtime and design‑time errors for debugging.  
  - `main.log` — General activity log for simulator events.  
  - `pin_state.log` — Maintains pin state traces for signal analysis.

- **Scenes (`/scenes`)** — Godot scene collections forming the visual blueprint of SimuLogic.  
  - `bus/` — Visual and functional layouts for data buses.  
  - `chip/` — Scene templates for chips, both primitive and composite.  
  - `input/` — Scene variants for input mechanisms.  
  - `panels/` — UI panels for workbench controls, inspectors, and libraries.  
  - `pins/` — Pin visuals and associated interaction layers.  
  - `ui/` — Global UI elements, overlays, and dialog systems.  
  - `wire/` — Wire visuals for connecting pins and managing signal paths.

- **Scripts (`/scripts`)** — All logic processing and utility systems written in GDScript.  
  - `bus/` — Data bus signal handling and routing logic.  
  - `chip/` — Chip construction, execution, and nesting behaviors.  
  - `communication/` — Signal propagation between components, including deferred updates.  
  - `error/` — Error tracking, reporting, and response handling.  
  - `input/` — Input device integration and state management.  
  - `logger/` — Core logging API for structured event tracking.  
  - `pin/` — Pin state changes, signal reception, and output propagation.  
  - `resources/` — Asset management for chip definitions, palettes, and presets.  
  - `ui/` — UI behavior scripts, inspector logic, and interaction patterns.  
  - `utils/` — General‑purpose utilities and helper functions.  
  - `wire/` — Wire state and signal forwarding logic.  
  - `working bench/` — Main simulation workspace logic, managing circuit layout and execution.

### Simulation Flow

1. **Signal Injection** — Inputs (manual or procedural) change pin states on the workbench.  
2. **Event‑Driven Propagation** — Only affected nodes compute updates, reducing unnecessary processing.  
3. **Visual Update** — Corresponding visual state (pins, wires, chips) refreshed in relevant scene layers.  
4. **Logging** — Every signal change, connection event, or error recorded in the appropriate log channel.  
5. **Persistence** — Circuit state saved for later reuse or exported to share with others.

## Screenshots and Demonstrations

This section showcases SimuLogic’s interactive capabilities, highlighting both its educational value and its technical depth. Each demonstration captures a distinct aspect of how circuits can be designed, explored, and debugged in real time.

### Nested Chip Design

![Nested Chip View](docs/assets/nested_chip_logic_units.gif)  
_An example of modular chip nesting with reusable logic blocks._

Complex systems in SimuLogic are built from the ground up, starting with primitive gates and progressing to composite chips. The **nested chip view** shows how larger architectures can consist of multiple encapsulated modules, each functioning as a reusable abstraction. This approach mirrors real-world design practices, encouraging scalability and clear separation of concerns.

### Signal Propagation

![Signal Propagation](docs/assets/signal_propagation.gif)  
_Demonstrates event-driven updates and stable feedback behavior._

Signals in SimuLogic flow through the circuit via a **precise, event-driven propagation system**, ensuring that only affected components recompute each frame. The demonstration highlights timing stability even in circuits with **feedback loops**, preventing race conditions through deferred propagation logic. Visual indicators make both active and resting states immediately identifiable.


### Component Library Interface

![Component Library](docs/assets/chip_library.gif)  
_Search and insert pre-built components into the workbench._

The **component library** is a searchable repository containing built-in primitives, user-defined chips, and imported modules. Components can be dragged directly onto the workbench and connected without manual configuration, supporting rapid prototyping and iterative experimentation. Each chip entry includes metadata for quick identification.


### Workbench Interaction

![Workbench Panning and Zooming](docs/assets/zooming_and_panning.gif)  
_Scalable design canvas supporting dynamic navigation._

SimuLogic’s workbench is a **highly scalable design canvas** with smooth panning, zooming, and snapping functionality. The demonstration shows how users can navigate large-scale circuits quickly, with responsive viewport adjustments that maintain visual clarity regardless of zoom level. This enables efficient work on both micro‑level details and macro‑level architectures.

## Motivation

SimuLogic began as a personal challenge: **simulate a computer from primitive logic gates inside a real-time, interactive environment.**  
Traditional electronics instruction often feels abstract and disconnected from experience, so the project was designed to let users _see_ and _feel_ signal propagation — visually, structurally, and interactively.

This hands‑on, gate‑first approach allows learners to build from **first principles**, starting with basic gates and gradually assembling increasingly sophisticated systems: adders, encoders, flip‑flops, memory modules, and display controllers. Each was implemented within SimuLogic itself, demonstrating the simulator’s **self‑hosted extensibility**.

The driving force behind SimuLogic is curiosity combined with clean, maintainable architecture. It is purpose‑built to separate logic processing from rendering, use event‑based signal propagation for performance, and embrace modularity so nested designs remain responsive.  
Every iteration followed professional engineering standards and Clean Code principles, resulting in a platform that proves academically rigorous tools can come from unconventional environments.


## Future Vision

SimuLogic is evolving toward simulating a **complete RISC‑based computer architecture**, demonstrating how minimal instruction sets and primitive gates can grow into fully functional systems through layered abstraction.

Planned developments include:

- **Multi‑Bit Pins** — handling wider data paths and bus connections.
- **Generalized Bus Systems** — enabling scalable data routing between components.
- **Dynamic Signal Generators** — clock pulse sources with adjustable frequency.
- **Advanced Modules** — ALUs, instruction decoders, synchronous memory, and other CPU‑level building blocks, all created with in‑sim tools.

The vision extends beyond technical features:  
SimuLogic aims to foster **community‑driven chip libraries**, collaborative circuit design workflows, and contributor guidelines to expand its ecosystem while preserving architectural integrity. This makes SimuLogic not only a solo research project, but also a shared platform for innovation.

In essence, SimuLogic’s future roadmap combines _technical rigor_, _educational clarity_, and _open collaboration_, breathing life into digital logic as both a subject of study and a playground for experimentation.

## License

This project is licensed under **MIT**, allowing open-source collaboration and modifications.
