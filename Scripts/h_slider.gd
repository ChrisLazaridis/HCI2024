extends HSlider

# Path to the Sprite2D node
@onready var pasalos_sprite = get_parent().get_parent().get_node("Minigame/Pasalos")

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Set the slider's range and starting value
	self.min_value = -15  # Minimum rotation in degrees
	self.max_value = 15   # Maximum rotation in degrees
	self.value = 0        # Start at 0 degrees (neutral)
	# Connect the "value_changed" signal to update the sprite's rotation
	self.connect("value_changed", Callable(self, "_on_slider_value_changed"))
	# Initialize the sprite's rotation to match the slider's starting value
	_on_slider_value_changed(self.value)

# Signal handler for the slider's value change
func _on_slider_value_changed(value: float) -> void:
	# Set the sprite's rotation in radians (Godot uses radians for rotation)
	pasalos_sprite.rotation_degrees = value
