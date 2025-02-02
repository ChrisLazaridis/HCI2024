extends Control

@onready var option_button = get_node("Panel/OptionButton")
@onready var tent_sprite = get_node("Sprite2D")


func _ready() -> void:
	option_button.connect("option_selected", Callable(self, "_on_index_changed"))

# In your Control script
func _on_index_changed(index: int) -> void:
	match index:
		0:
			# Reading
			tent_sprite.texture = load("res://assets/Tents/TENT_Reading.png")
			tent_sprite._stop_animation()
		1:
			# Sleep
			tent_sprite.texture = load("res://assets/Tents/TENT_Sleep.png")
			tent_sprite._stop_animation()
		2:
			# Dinner
			tent_sprite.texture = load("res://assets/Tents/rainbow/TENT_KITRINO.png")
			tent_sprite._stop_animation()
		3:
			# Rainbow
			tent_sprite._start_animation()


func _on_button_pressed() -> void:
	pass # Replace with function body.
