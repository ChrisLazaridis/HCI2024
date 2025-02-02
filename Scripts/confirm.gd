extends Button

signal pickets_placed

@onready var progress_label = get_parent().get_parent().get_node("Panel2/Label")
@onready var pasalos_sprite = get_parent().get_parent().get_node("Minigame/Pasalos")
@onready var label_valid = get_parent().get_parent().get_node("Minigame/Panel/Panel/Label_Valid")
@onready var label_invalid = get_parent().get_parent().get_node("Minigame/Panel/Panel/Label_Invalid")
func _process(delta):
	var depth = pasalos_sprite.position.y
	if depth > 96:
		label_valid.set_visible(true)
		label_invalid.set_visible(false)
	else:
		label_valid.set_visible(false)
		label_invalid.set_visible(true)
		
func _on_pressed() -> void:
	var depth = pasalos_sprite.position.y
	if depth > 96:
		match progress_label.text:
			"1/4": progress_label.text = "2/4"
			"2/4": progress_label.text = "3/4"
			"3/4": 
				progress_label.text = "4/4"
				emit_signal("pickets_placed")
			_: emit_signal("pickets_placed")
