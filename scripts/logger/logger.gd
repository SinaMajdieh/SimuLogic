extends Node

# Directory for storing log files
const log_dir: String = "res://logs/"

# Enum defining log categories
enum Logs {MAIN, CONNECTIONS, PIN_STATE, ERRORS}

# Dictionary mapping log categories to file names
var logs: Dictionary[Logs, String] = {
	Logs.MAIN: "main.log",
	Logs.CONNECTIONS: "connections.log",
	Logs.PIN_STATE: "pin_state.log",
	Logs.ERRORS: "error.log"
}

# Dictionary for storing active file handles
var log_files: Dictionary[Logs, FileAccess] = {}

# Ensures the log directory exists and clears old logs on startup
func _ready() -> void:
	DirAccess.make_dir_absolute(log_dir)  # Create the logs directory if it doesn't exist
	
	# Initialize log files by resetting their content
	for log_file in logs.values():
		var file: FileAccess = FileAccess.open(log_dir + log_file, FileAccess.WRITE)
		file.close()  # Immediately close the file to ensure it's reset

# Logs a message under the specified category
func log(category: Logs, message: String, print_to_console: bool = false) -> void:
	# Ensure the given category exists in the dictionary
	if not logs.has(category):
		push_warning("Unknown log category: %s" % category)
		return

	# Open log file if it hasn't been initialized yet
	if not log_files.has(category):
		var full_path: String = log_dir + logs[category]
		log_files[category] = FileAccess.open(full_path, FileAccess.READ_WRITE)

	# Move to the end of the file and store the message
	log_files[category].seek_end()
	log_files[category].store_line(message)
	
	# Optionally print the message to the debug console
	if print_to_console:
		print(message)

# Ensures all log files are properly closed when the node exits
func _exit_tree() -> void:
	for log_file in log_files.values():
		if log_file.is_open():
			log_file.close()

# Logs a message with a timestamp for better traceability
func log_with_time(category: Logs, message: String, print_to_console: bool = false) -> void:
	var time_stamp: String = Time.get_datetime_string_from_system()
	Logger.log(category, "[%s] %s" % [time_stamp, message], print_to_console)
