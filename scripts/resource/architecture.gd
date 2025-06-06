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


# === CHIP BLUEPRINT DIRECTORY ===
# Defines the default location where chip blueprints are stored.
@export var chips_schematic_path: String = "res://blue_prints/"

var editale_chips: bool = true

signal new_schematic_added(schematic: ChipBlueprint)

# ======================
# SAVE CHIP BLUEPRINT
# ----------------------
# Stores a chip blueprint as a `.tres` resource file.
# Provides error handling and logs success or failure.
# ======================
func save_blueprint(bp: ChipBlueprint, file_name: String) -> void:
    # Construct the full save path for the blueprint
    var save_path: String = "%s/%s.tres" % [BLUEPRINTS_PATH, file_name]

    # Attempt to save the resource and capture any errors
    var error: Error = ResourceSaver.save(bp, save_path)

    # Handle possible errors and provide debug feedback
    if error != OK:
        Logger.log(Logger.Logs.ERRORS, "Failed to save resource: %s" % error, true)
    else:
        Logger.log(Logger.Logs.MAIN, "Chip saved as %s.tres" % file_name, true)
        new_schematic_added.emit(bp)

# ======================
# LOAD CHIP LIBRARY
# ----------------------
# Scans a directory for stored chip blueprints and adds them to the UI.
# ======================
func load_schematics(directory_path: String = chips_schematic_path) -> Array[ChipBlueprint]:
    var schematics: Array[ChipBlueprint] = []
    var dir: DirAccess = DirAccess.open(directory_path)
    if dir:
        var files: PackedStringArray = dir.get_files()
        for file_name in files:
            # Filter only blueprint files
            if file_name.ends_with(".tres") or file_name.ends_with(".res"):
                var resource: Resource = load("%s%s" % [directory_path, file_name]) as ChipBlueprint
                if resource:
                    schematics.append(resource)
    return schematics
