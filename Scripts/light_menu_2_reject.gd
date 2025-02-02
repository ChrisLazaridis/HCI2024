extends Button

signal reject

func _pressed() -> void:
	emit_signal("reject")
