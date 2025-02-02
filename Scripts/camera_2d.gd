extends Camera2D
@export var target_sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if target_sprite and target_sprite.texture:
		# Get the size of the sprite's texture
		var sprite_size = target_sprite.texture.get_size()

		# Get the size of the viewport (screen size)
		var screen_size = get_viewport().size

		# Calculate the zoom factor to match the sprite size
		zoom = Vector2(sprite_size.x / screen_size.x, sprite_size.y / screen_size.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
