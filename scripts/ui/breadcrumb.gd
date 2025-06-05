class_name Breadcrumb
extends HBoxContainer

# ======================
# BREADCRUMB NAVIGATION UI:
# ----------------------
# This class manages breadcrumb navigation elements for hierarchical paths.
# It dynamically generates buttons and separators based on the current path.
# ======================

# === TEMPLATE ELEMENTS ===
# Defines UI components for breadcrumb buttons and separators.
@export var template_button: Button  # Represents each breadcrumb step
@export var template_label: Label  # Separator between breadcrumb steps

# === SIGNAL DEFINITIONS ===
# Emits events when breadcrumb buttons are clicked.
signal breadcrumb_clicked(index: int)

# === PATH STORAGE ===
# Stores the breadcrumb path as an array of strings.
var path: Array[String] = []

# ======================
# SET BREADCRUMB PATH
# ----------------------
# Updates the stored path and refreshes the breadcrumb display.
# ======================
func set_path(new_path: Array[String]) -> void:
    path = new_path
    update_breadcrumb()

# ======================
# UPDATE BREADCRUMB UI
# ----------------------
# Reconstructs the breadcrumb navigation UI dynamically.
# Removes old elements and creates new ones based on the current path.
# ======================
func update_breadcrumb() -> void:
    # Remove all dynamically created breadcrumb elements
    for child: Node in get_children():
        if child == template_button or child == template_label:
            continue
        remove_child(child)
        child.queue_free()

    # Populate breadcrumbs based on the path
    for i: int in path.size():
        var btn: Button = template_button.duplicate()
        btn.disabled = false
        btn.text = path[i]
        
        # Connect button press signal for navigation
        btn.pressed.connect(_on_breadcrumb_pressed.bind(i))
        add_child(btn)

        # Add separators between breadcrumbs, except for the last one
        if i < path.size() - 1:
            var sep: Label = template_label.duplicate()
            sep.visible = true
            add_child(sep)

# ======================
# HANDLE BREADCRUMB NAVIGATION
# ----------------------
# Emits a signal when a breadcrumb button is clicked, passing its index.
# ======================
func _on_breadcrumb_pressed(index: int) -> void:
    breadcrumb_clicked.emit(index)
