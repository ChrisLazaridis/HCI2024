extends Button

signal pickets_rejected

func _on_pressed() -> void:
	emit_signal("pickets_rejected")
