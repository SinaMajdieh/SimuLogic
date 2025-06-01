class_name Breadcrumb
extends HBoxContainer

# Template elements for breadcrumb buttons and separators
@export var template_button: Button  # Button representing each breadcrumb step
@export var template_label: Label  # Separator between breadcrumb steps

# Signal emitted when a breadcrumb is clicked, passing its index
signal breadcrumb_clicked(index: int)

# Stores the breadcrumb path as an array of strings
var path: Array[String] = []

# Sets the breadcrumb path and updates the display
func set_path(new_path: Array[String]) -> void:
    path = new_path
    update_breadcrumb()

# Updates the breadcrumb UI based on the current path
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
        
        # Connect button press signal to breadcrumb navigation
        btn.pressed.connect(_on_breadcrumb_pressed.bind(i))
        add_child(btn)

        # Add separators between breadcrumbs, except for the last one
        if i < path.size() - 1:
            var sep: Label = template_label.duplicate()
            sep.visible = true
            add_child(sep)

# Handles breadcrumb button click events and emits the navigation signal
func _on_breadcrumb_pressed(index: int) -> void:
    breadcrumb_clicked.emit(index)
