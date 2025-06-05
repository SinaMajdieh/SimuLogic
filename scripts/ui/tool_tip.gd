extends PanelContainer

# Offset for tooltip positioning relative to the mouse cursor
var offset = Vector2(10, 10)

# Flag to determine if the tooltip is active
var active = false

# Initializes the tooltip by making it invisible at startup
func _ready() -> void:
    visible = false

# Updates tooltip position dynamically based on the mouse cursor
func _process(_delta: float) -> void:
    if active:
        var mouse_pos = get_global_mouse_position()

        # Ensure the tooltip stays within screen bounds
        if mouse_pos.x + size.x + offset.x > get_viewport_rect().size.x:
            mouse_pos.x -= size.x + offset.x  # Adjust position if overflowing horizontally
        if mouse_pos.y + size.y + offset.y > get_viewport_rect().size.y:
            mouse_pos.y -= size.y + offset.y  # Adjust position if overflowing vertically

        # Set the tooltip's position with applied offset
        position = mouse_pos + offset

# Displays the tooltip with the specified text
func show_tooltip(text: String) -> void:
    $MarginContainer/Label.text = text  # Update tooltip text
    visible = true  # Make tooltip visible
    active = true  # Activate tooltip tracking

# Hides the tooltip and stops tracking
func hide_tooltip() -> void:
    visible = false  # Hide tooltip
    active = false  # Deactivate tracking
