extends Node

# ======================
# LOGGING SYSTEM:
# ----------------------
# This class manages logging operations for debugging and tracing events.
# It stores log messages across multiple categories and ensures proper file handling.
# ======================

# === LOG DIRECTORY ===
# Defines the location where log files are stored.
const log_dir: String = "res://logs/"

# === LOG CATEGORIES ENUMERATION ===
# Specifies different logging types for organized debugging.
enum Logs {MAIN, CONNECTIONS, PIN_STATE, ERRORS}

# === LOG FILE MAPPING ===
# Associates log categories with their respective filenames.
var logs: Dictionary[Logs, String] = {
    Logs.MAIN: "main.log",
    Logs.CONNECTIONS: "connections.log",
    Logs.PIN_STATE: "pin_state.log",
    Logs.ERRORS: "error.log"
}

# === ACTIVE LOG FILE HANDLES ===
# Stores open file handles for logging operations.
var log_files: Dictionary[Logs, FileAccess] = {}

# ======================
# INITIALIZE LOGGING SYSTEM
# ----------------------
# Ensures the log directory exists and clears old log files upon startup.
# ======================
func _ready() -> void:
    DirAccess.make_dir_absolute(log_dir)  # Create the logs directory if it doesn't exist
    
    # Reset log files by clearing their content
    for log_file in logs.values():
        var file: FileAccess = FileAccess.open(log_dir + log_file, FileAccess.WRITE)
        file.close()  # Close the file immediately after resetting

# ======================
# LOG MESSAGE TO FILE
# ----------------------
# Stores a message under the specified log category.
# Optionally prints the message to the console.
# ======================
func log(category: Logs, message: String, print_to_console: bool = false) -> void:
    # Ensure the provided category is valid
    if not logs.has(category):
        push_warning("Unknown log category: %s" % category)
        return

    # Open the log file if it hasn't been initialized
    if not log_files.has(category):
        var full_path: String = log_dir + logs[category]
        log_files[category] = FileAccess.open(full_path, FileAccess.READ_WRITE)

    # Append the message to the log file
    log_files[category].seek_end()
    log_files[category].store_line(message)
    
    # Print the log message to the debug console if enabled
    if print_to_console:
        print(message)

# ======================
# CLEANUP LOG FILES ON EXIT
# ----------------------
# Ensures all log files are properly closed when the node exits.
# ======================
func _exit_tree() -> void:
    for log_file in log_files.values():
        if log_file.is_open():
            log_file.close()

# ======================
# LOG MESSAGE WITH TIMESTAMP
# ----------------------
# Stores a log message prefixed with a timestamp for improved traceability.
# ======================
func log_with_time(category: Logs, message: String, print_to_console: bool = false) -> void:
    var time_stamp: String = Time.get_datetime_string_from_system()
    Logger.log(category, "[%s] %s" % [time_stamp, message], print_to_console)
