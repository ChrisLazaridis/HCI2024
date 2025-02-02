extends Button

signal reject

func _on_button_pressed():
	emit_signal("reject")
