class_name Arch
extends Node

# Path for storing blueprint resources
const BLUEPRINTS_PATH: String = "res://blue_prints"

# Saves a chip blueprint to a `.tres` resource file
static func save_blueprint(bp: ChipBlueprint, file_name: String) -> void:
    # Construct the full save path for the blueprint
    var save_path: String = "%s/%s.tres" % [BLUEPRINTS_PATH, file_name]

    # Attempt to save the resource and capture any errors
    var error: Error = ResourceSaver.save(bp, save_path)

    # Handle possible errors and provide debug feedback
    if error != OK:
        Logger.log(Logger.Logs.ERRORS, "Failed to save resource: %s" % error)
    else:
        Logger.log(Logger.Logs.MAIN, "Chip saved as %s.tres" % file_name)
