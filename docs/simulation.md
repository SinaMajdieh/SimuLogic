# Simulation Engine

The simulation operates in discrete frames. Each node processes a limited number of updates per frame, with overflow deferred to subsequent cycles. Signal propagation is event-driven, ensuring only affected components are updated.

This design supports feedback loops and avoids instability or flickering in signal states.
