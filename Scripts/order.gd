extends Button

@export var battery_menu_scene_path: String = "res://Scenes/order_menu.tscn"
signal ordered

var order_menu_instance: Control = null
signal battery_mode_selected(mode: String)

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	if order_menu_instance == null:
		var order_menu_scene = load(battery_menu_scene_path)
		if order_menu_scene is PackedScene:
			order_menu_instance = order_menu_scene.instantiate()
			_position_menu_instance(order_menu_instance)
			# Connect the 'confirmed' signal from the battery menu
			order_menu_instance.connect("closed", Callable(self, "_on_closed"))
			get_tree().root.add_child(order_menu_instance)
	else:
		print("order menu is already instantiated.")


func _on_closed(arg) -> void:
	if order_menu_instance:
		order_menu_instance.queue_free()
		order_menu_instance = null
	if arg == "confirmed":
		emit_signal("ordered")

func _position_menu_instance(menu_instance: Node) -> void:
	var camera = get_parent().get_node("Sprite2D/Camera")
	if camera and camera is Camera2D:
		var camera_center = camera.global_position
		var offset = Vector2(-50, -150)
		menu_instance.position = camera_center + offset
	else:
		print("Camera is not available. Defaulting to (0, 0).")
		menu_instance.position = Vector2.ZERO
