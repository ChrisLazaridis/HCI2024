extends Button

signal confirm

func _on_button_pressed():
	emit_signal("confirm")
