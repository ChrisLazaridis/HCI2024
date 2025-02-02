extends Panel
@onready var q_label = get_node("QPanel/QLabel")
@onready var all_label = get_parent().get_node("Panel2/Label")
@onready var plus_btn = get_node("+")
@onready var minus_btn = get_node("-")


func _ready() -> void:
	plus_btn.connect("pressed", Callable(self, "_on_plus"))
	minus_btn.connect("pressed", Callable(self, "_on_minus"))

func _on_plus():
	var quantity = int(q_label.text)
	quantity += 1
	q_label.text = str(quantity)
	var value = float(all_label.text)
	value += 0.50
	all_label.text = str(value)
	
func _on_minus():
	var quantity = int(q_label.text)
	if quantity > 0:
		quantity -= 1
		q_label.text = str(quantity)
		var value = float(all_label.text)
		value -= 0.50
		all_label.text = str(value)
