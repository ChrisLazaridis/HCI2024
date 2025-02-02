extends Control

@export var locked_vertical_offset: float = 10  # Distance above the lower end of the minigame panel
@export var horizontal_margin: float = 75  # Horizontal margin for validation relative to the minigame panel
@export var move_speed: float = 200  # Speed of movement (pixels per second)
@export var validation_shift_range: int = 20  # Maximum shift range for validation boundaries

signal placement_valid  # Signal emitted when placement is valid
signal placement_invalid  # Signal emitted when placement is invalid

var randomized_range = Vector2()
@onready var sprite = get_node("Sprite2D")  # Reference the Sprite2D node

func _ready():
	# Get reference to the minigame panel
	var minigame_panel = get_parent()
	if not minigame_panel:
		print("Error: Minigame panel not found!")
		return

	# Calculate the validation range based on the minigame panel's size
	var panel_size = minigame_panel.size  # Get the size of the minigame panel
	var shift = randi() % (validation_shift_range * 2 + 1) - validation_shift_range  # Random shift (-range to +range)
	randomized_range = Vector2(horizontal_margin + shift, panel_size.x - horizontal_margin + shift)
	print("Randomized range:", randomized_range)

	# Set the tarp's initial position (centered horizontally within the panel)
	position.x = panel_size.x / 2

	# Align the sprite's position to match the Control node
	sprite.position = position

func _process(delta):
	# Handle movement with arrow keys
	if Input.is_action_pressed("right_arrow"):
		position.x += move_speed * delta
	elif Input.is_action_pressed("left_arrow"):
		position.x -= move_speed * delta


	# Update the sprite's position to match the Control's position
	sprite.position = position

	# Check if the position is valid and emit the appropriate signal
	_validate_position()

func _validate_position():
	# Check if the tarp's position is within the randomized validation range
	if randomized_range.x <= position.x && position.x <= randomized_range.y:
		emit_signal("placement_valid")
		print("Placement valid:", position.x)
	else:
		emit_signal("placement_invalid")
		print("Placement invalid:", position.x)
