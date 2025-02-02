# Manual Button Script
extends Button

signal manual_action()

func _on_button_pressed() -> void:
	emit_signal("manual_action")
	print("emiting manual signal")
