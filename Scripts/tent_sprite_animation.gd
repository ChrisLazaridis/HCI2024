extends Sprite2D

@export var frame_duration: float = 0.3
@export var textures: Array[Texture2D] = [
	load("res://assets/Tents/rainbow/TENT_Green.png"),
	load("res://assets/Tents/rainbow/TENT_KITRINO.png"),
	load("res://assets/Tents/rainbow/TENT_KOKKINO.png"),
	load("res://assets/Tents/rainbow/TENT_Pink.png")
]

var animation_play: bool = false
var current_frame: int = 0
var time_accumulator: float = 0.0

func _process(delta: float) -> void:
	if animation_play:
		time_accumulator += delta
		if time_accumulator >= frame_duration:
			time_accumulator -= frame_duration
			current_frame = (current_frame + 1) % textures.size()
			texture = textures[current_frame]

func _start_animation() -> void:
	animation_play = true
	current_frame = 0
	time_accumulator = 0.0
	texture = textures[current_frame]

func _stop_animation() -> void:
	animation_play = false
