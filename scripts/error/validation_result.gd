class_name ValidationResult
extends Object

# ======================
# VALIDATION RESULT OBJECT:
# ----------------------
# This class represents a validation result.
# It stores a boolean indicating validity and an optional message.
# ======================

# === VALIDITY STATUS ===
# Indicates whether the validation was successful.
var valid: bool

# === VALIDATION MESSAGE ===
# Stores an optional message providing additional information.
var message: String

# ======================
# INITIALIZE VALIDATION RESULT
# ----------------------
# Sets the validation status and optional message upon instantiation.
# ======================
func _init(valid_: bool, msg: String = "") -> void:
    valid = valid_
    message = msg
