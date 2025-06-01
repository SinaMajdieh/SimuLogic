class_name PreciseTimer
extends Node

# Stores the starting time in microseconds
var start_time: int

# Duration for the timer in microseconds
var target_duration: int

# Tracks whether the timer is actively running
var timer_active: bool = false

# Signal emitted when the timer reaches its duration
signal time_out()

# Starts the timer with the specified duration in microseconds
func start_timer(duration_usec: int) -> void:
    start_time = Time.get_ticks_usec()  # Capture the current system timestamp
    target_duration = duration_usec
    timer_active = true  # Activate the timer

# Continuously checks if the timer has completed
func _process(_delta: float) -> void:
    if timer_active and Time.get_ticks_usec() - start_time >= target_duration:
        timer_active = false  # Stop the timer
        time_out.emit()  # Emit the timeout signal
