extends Control

@onready var confirm = get_node("Panel/Confirm")
@onready var option = get_node("OptionButton")
@onready var mode = "full"

signal confirmed(mode: String)

func _ready():
	confirm.connect("confirm", Callable(self, "_on_confirm"))
	option.connect("item_selected", Callable(self, "_on_option_changed"))

func _on_option_changed(index):
	if index == 0:
		mode = "full"
		
	elif index == 1:
		mode = "moderate"
		
	elif index == 2:
		mode = "save"
		

func _on_confirm():
	emit_signal("confirmed", mode)
	
