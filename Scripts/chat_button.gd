extends Button

@export var chat_menu_scene_path: String = "res://Scenes/chat.tscn"

var chat_menu_instance: Control = null

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	if chat_menu_instance == null:
		var chat_menu_scene = load(chat_menu_scene_path)
		if chat_menu_scene is PackedScene:
			chat_menu_instance = chat_menu_scene.instantiate()
			_position_menu_instance(chat_menu_instance)
			# Connect the 'pressed' signal from the Close button within the chat menu
			var close_button = chat_menu_instance.get_node("Panel/Close")
			if close_button:
				close_button.connect("pressed", Callable(self, "_on_chat_menu_close_pressed"))
			get_tree().root.add_child(chat_menu_instance)
	else:
		print("Chat menu is already instantiated.")

func _on_chat_menu_close_pressed() -> void:
	_remove_chat_menu()

func _remove_chat_menu() -> void:
	if chat_menu_instance:
		chat_menu_instance.queue_free()
		chat_menu_instance = null

func _position_menu_instance(menu_instance: Control) -> void:
	var camera = get_parent().get_node("Sprite2D/Camera")
	if camera and camera is Camera2D:
		var camera_center = camera.global_position
		var offset = Vector2(-200, -150)
		menu_instance.position = camera_center + offset
	else:
		print("Camera is not available. Defaulting to (0, 0).")
		menu_instance.position = Vector2.ZERO
