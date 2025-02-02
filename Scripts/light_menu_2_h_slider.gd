extends HSlider

@onready var progress_bar = get_parent().get_node("ProgressBar")
signal new_value(value: float)

func _value_changed(value: float) -> void:
	# Update the ProgressBar's value
	progress_bar.set_value(value)
	# Emit the custom changed signal
	emit_signal("new_value", value)
