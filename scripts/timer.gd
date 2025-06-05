class_name PreciseTimer
extends Node

# ======================
# HIGH-PRECISION TIMER:
# ----------------------
# This class manages a microsecond-accurate timer.
# It tracks elapsed time and emits a signal when the duration expires.
# ======================

# === TIMER STATE TRACKING ===
# Stores the starting time and target duration in microseconds.
var start_time: int
var target_duration: int

# === TIMER ACTIVE STATUS ===
# Determines whether the timer is currently running.
var timer_active: bool = false

# ======================
# SIGNAL DEFINITIONS
# ----------------------
# Emits an event when the timer reaches the specified duration.
# ======================
signal time_out()

# ======================
# START TIMER
# ----------------------
# Initializes the timer with a specified duration in microseconds.
# ======================
func start_timer(duration_usec: int) -> void:
    start_time = Time.get_ticks_usec()  # Capture the current system timestamp
    target_duration = duration_usec
    timer_active = true  # Activate the timer

# ======================
# TIMER PROCESSING LOOP
# ----------------------
# Continuously checks if the timer has completed.
# Emits a signal when the duration is reached.
# ======================
func _process(_delta: float) -> void:
    if timer_active and Time.get_ticks_usec() - start_time >= target_duration:
        timer_active = false  # Stop the timer
        time_out.emit()  # Emit the timeout signal
