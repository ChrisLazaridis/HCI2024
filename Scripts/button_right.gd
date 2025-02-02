extends Button

@onready var sprite = get_parent().get_node("minigame/tarp/Sprite2D")

func _pressed():
	var new_texture = load("res://assets/Tarps/Tarp_right_side.png")
	if sprite and new_texture:
		sprite.texture = new_texture
	else:
		print("Error: Sprite node or texture not found.")
