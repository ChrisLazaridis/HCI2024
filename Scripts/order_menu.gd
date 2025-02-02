extends Control
@onready var confirm_btn = get_node("Panel/Confirm")
@onready var reject_btn = get_node("Panel/Reject")

signal closed(arg: String)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	confirm_btn.connect("pressed", Callable(self,"_on_btn_confirmed"))
	reject_btn.connect("pressed", Callable(self,"_on_btn_rejected"))
	


func _on_btn_confirmed():
	emit_signal("closed", "confirmed")

func _on_btn_rejected():
	emit_signal("closed", "rejected")
