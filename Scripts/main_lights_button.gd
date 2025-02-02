extends Button

@export var light_menu_scene_path: String = "res://Scenes/light_menu_1.tscn"
@export var second_menu_scene_path: String = "res://Scenes/light_menu_2.tscn"
@export var rainbow_textures: Array[String] = [
	"res://assets/Tents/rainbow/TENT_Green.png",
	"res://assets/Tents/rainbow/TENT_KITRINO.png",
	"res://assets/Tents/rainbow/TENT_KOKKINO.png",
	"res://assets/Tents/rainbow/TENT_Pink.png"
]
@export var frame_duration: float = 0.3

var light_menu_instance: Node = null
var second_menu_instance: Node = null
var animation_play: bool = false
var current_frame: int = 0
var time_accumulator: float = 0.0
var target_sprite: Sprite2D = null

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	if light_menu_instance == null:
		var light_menu_scene = load(light_menu_scene_path)
		if light_menu_scene is PackedScene:
			light_menu_instance = light_menu_scene.instantiate()
			_position_menu_instance(light_menu_instance)
			# Connect signals from the light menu buttons
			var select_button = light_menu_instance.get_node("Panel/Select")
			var manual_button = light_menu_instance.get_node("Panel/Manual")
			select_button.connect("selected_preset", Callable(self, "_on_selected_preset"))
			manual_button.connect("manual_action", Callable(self, "_on_manual_action"))
			get_tree().root.add_child(light_menu_instance)
	else:
		print("Light menu is already instantiated.")

func _on_selected_preset(index: int) -> void:
	_remove_light_menu()
	_initialize_target_sprite()
	if target_sprite:
		match index:
			0:
				target_sprite.texture = load("res://assets/Tents/TENT_Reading.png")
				_stop_animation()
			1:
				target_sprite.texture = load("res://assets/Tents/TENT_Sleep.png")
				_stop_animation()
			2:
				target_sprite.texture = load("res://assets/Tents/rainbow/TENT_KITRINO.png")
				_stop_animation()
			3:
				_start_animation()
			_:
				target_sprite.texture = load("res://assets/Tents/TENT_MAURH_PISA.png")
				_stop_animation()
	else:
		print("Target sprite not found.")

func _on_manual_action() -> void:
	_remove_light_menu()
	var second_menu_scene = load(second_menu_scene_path)
	if second_menu_scene is PackedScene:
		second_menu_instance = second_menu_scene.instantiate()
		_position_menu_instance(second_menu_instance)
		# Connect rejection and confirmation signals
		second_menu_instance.connect("selected_color", Callable(self, "_on_manual_confirm"))
		second_menu_instance.connect("rejected_lights", Callable(self, "_on_manual_reject"))
		get_tree().root.add_child(second_menu_instance)

func _on_manual_confirm(color: Color, effect: String, brightness: float) -> void:
	_initialize_target_sprite()
	if target_sprite:
		target_sprite.texture = load(rainbow_textures[0])  # Start with the first frame of rainbow
		_start_animation()
	else:
		print("Target sprite not found.")
	_remove_second_menu()

func _on_manual_reject() -> void:
	_initialize_target_sprite()
	if target_sprite:
		target_sprite.texture = load("res://assets/Tents/TENT_MAURH_PISA.png")
		_stop_animation()
	else:
		print("Target sprite not found.")
	_remove_second_menu()

func _remove_light_menu() -> void:
	if light_menu_instance:
		light_menu_instance.queue_free()
		light_menu_instance = null

func _remove_second_menu() -> void:
	if second_menu_instance:
		second_menu_instance.queue_free()
		second_menu_instance = null

func _position_menu_instance(menu_instance: Node) -> void:
	var camera = get_parent().get_node("Sprite2D/Camera")
	if camera and camera is Camera2D:
		var camera_center = camera.global_position
		var offset = Vector2(-50, -100)
		menu_instance.position = camera_center + offset
	else:
		print("Camera is not available. Defaulting to (0, 0).")
		menu_instance.position = Vector2.ZERO

func _initialize_target_sprite() -> void:
	target_sprite = null
	var top_left_tent = get_node_or_null("/root/Node2D/Top_Left/tent")
	var bottom_left_tent = get_node_or_null("/root/Node2D/Bottom Left/tent")

	if top_left_tent and top_left_tent is Sprite2D:
		target_sprite = top_left_tent
	elif bottom_left_tent and bottom_left_tent is Sprite2D:
		target_sprite = bottom_left_tent

	if target_sprite == null:
		print("No 'tent' Sprite2D node found in Top_Left or Bottom_Left.")

func _start_animation() -> void:
	animation_play = true
	current_frame = 0
	time_accumulator = 0.0
	if target_sprite:
		target_sprite.texture = load(rainbow_textures[current_frame])
	else:
		print("Cannot start animation; target sprite is null.")

func _stop_animation() -> void:
	animation_play = false

func _process(delta: float) -> void:
	if animation_play and target_sprite:
		time_accumulator += delta
		if time_accumulator >= frame_duration:
			time_accumulator -= frame_duration
			current_frame = (current_frame + 1) % rainbow_textures.size()
			target_sprite.texture = load(rainbow_textures[current_frame])
	elif animation_play:
		print("Cannot animate; target sprite is null.")
