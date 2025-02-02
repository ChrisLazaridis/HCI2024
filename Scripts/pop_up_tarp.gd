extends Window

signal manual_selected  # Signal emitted when "Manual Placement" is chosen
signal automatic_selected  # Signal emitted when "Automatic Placement" is chosen

@onready var manual_button = $VBoxContainer/ManualButton
@onready var automatic_button = $VBoxContainer/AutomaticButton

func _ready():
	manual_button.connect("pressed", Callable(self, "_on_manual_selected"))
	automatic_button.connect("pressed", Callable(self, "_on_automatic_selected"))

func _on_manual_selected():
	emit_signal("manual_selected")  # Emit signal for manual placement
	queue_free()  # Close and remove the pop-up

func _on_automatic_selected():
	emit_signal("automatic_selected")  # Emit signal for automatic placement
	queue_free()  # Close and remove the pop-up
