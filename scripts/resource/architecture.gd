class_name Arch
extends Node

# ======================
# CHIP BLUEPRINT MANAGEMENT:
# ----------------------
# This class handles the saving of chip blueprints as `.tres` resource files.
# It ensures correct file path formatting and provides debug feedback.
# ======================

# === BLUEPRINT STORAGE PATH ===
# Defines the directory where blueprint resources are saved.
const BLUEPRINTS_PATH: String = "res://blue_prints"

# ======================
# SAVE CHIP BLUEPRINT
# ----------------------
# Stores a chip blueprint as a `.tres` resource file.
# Provides error handling and logs success or failure.
# ======================
static func save_blueprint(bp: ChipBlueprint, file_name: String) -> void:
    # Construct the full save path for the blueprint
    var save_path: String = "%s/%s.tres" % [BLUEPRINTS_PATH, file_name]

    # Attempt to save the resource and capture any errors
    var error: Error = ResourceSaver.save(bp, save_path)

    # Handle possible errors and provide debug feedback
    if error != OK:
        Logger.log(Logger.Logs.ERRORS, "Failed to save resource: %s" % error, true)
    else:
        Logger.log(Logger.Logs.MAIN, "Chip saved as %s.tres" % file_name, true)
