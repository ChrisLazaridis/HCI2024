extends Button

signal reject_pressed  # Signal to notify the manager

func _ready():
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed():
	emit_signal("reject_pressed")
