class_name LogicUtils

# ======================
# LOGIC STATE UTILITY:
# ----------------------
# This class provides helper functions for handling logic states.
# It converts between boolean values and three-state logic (LOW, HIGH, Z).
# ======================

# === LOGIC STATE ENUMERATION ===
# Defines possible states for logic signals.
enum State {LOW, HIGH, Z}

# ======================
# CONVERT STATE TO BOOLEAN
# ----------------------
# Maps HIGH to `true`, LOW and Z to `false`.
# ======================
static func to_bool(state: State) -> bool:
    match state:
        State.HIGH:
            return true
        State.LOW, State.Z:
            return false
        _:
            return false

# ======================
# CONVERT BOOLEAN TO LOGIC STATE
# ----------------------
# Maps `true` to HIGH and `false` to LOW.
# ======================
static func from_bool(value: bool) -> State:
    return State.HIGH if value else State.LOW

# ======================
# CHECK IF STATE IS HIGH
# ----------------------
# Returns `true` if the state is HIGH.
# ======================
static func is_high(state: State) -> bool:
    return state == State.HIGH

# ======================
# CHECK IF STATE IS LOW
# ----------------------
# Returns `true` if the state is LOW.
# ======================
static func is_low(state: State) -> bool:
    return state == State.LOW

# ======================
# CHECK IF STATE IS HIGH IMPEDANCE
# ----------------------
# Returns `true` if the state is Z (high impedance).
# ======================
static func is_high_impedance(state: State) -> bool:
    return state == State.Z
