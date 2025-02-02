extends Button

signal confirm

func _pressed() -> void:
	emit_signal("confirm")
