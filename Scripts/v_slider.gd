extends VSlider

# Path to the Sprite2D node
@onready var pasalos_sprite = get_parent().get_parent().get_node("Minigame/Pasalos")

# Called when the node enters the scene tree for the first time
func _ready() -> void:
	# Set the slider's range and starting value
	self.min_value = 92  # Minimum y-axis position
	self.max_value = 103  # Maximum y-axis position
	self.value = 92  # Start at 92 px
	# Connect the "value_changed" signal to update the sprite's y-position
	self.connect("value_changed", Callable(self, "_on_slider_value_changed"))
	# Initialize the sprite's y-position to match the slider's starting value
	_on_slider_value_changed(self.value)

# Signal handler for the slider's value change
func _on_slider_value_changed(value: float) -> void:
	# Set the sprite's y-position directly based on the slider's value
	pasalos_sprite.position.y = value
