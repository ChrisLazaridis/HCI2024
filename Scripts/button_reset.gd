extends Button

@onready var tarp_node = get_parent().get_node("tarp")
@onready var sprite_node = tarp_node.get_node("Sprite2D")

func _pressed():

	# Load the new texture
	var new_texture = load("res://assets/Tarps/Tarp_Up_Front.png")
	if new_texture:
		# Assign the new texture to the Sprite2D node
		sprite_node.texture = new_texture
	else:
		print("Error: Texture not found at the specified path.")
