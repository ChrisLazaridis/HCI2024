# Select Button Script
extends Button

signal selected_preset(index: int)

@onready var option_button = get_parent().get_node("OptionButton")

func _on_button_pressed() -> void:
	var selected_index = option_button.selected
	if selected_index >= 0:
		emit_signal("selected_preset", selected_index)
		print("emiting select signal")
	else:
		print("No option selected.")
