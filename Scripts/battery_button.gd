extends Button

@export var battery_menu_scene_path: String = "res://Scenes/battery_menu.tscn"

var battery_menu_instance: Control = null
signal battery_mode_selected(mode: String)

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	if battery_menu_instance == null:
		var battery_menu_scene = load(battery_menu_scene_path)
		if battery_menu_scene is PackedScene:
			battery_menu_instance = battery_menu_scene.instantiate()
			_position_menu_instance(battery_menu_instance)
			# Connect the 'confirmed' signal from the battery menu
			battery_menu_instance.connect("confirmed", Callable(self, "_on_battery_mode_confirmed"))
			get_tree().root.add_child(battery_menu_instance)
	else:
		print("Battery menu is already instantiated.")

func _on_battery_mode_confirmed(mode: String) -> void:
	print("Battery mode selected:", mode)
	# Emit the mode to the manager
	emit_signal("battery_mode_selected", mode)
	_remove_battery_menu()

func _remove_battery_menu() -> void:
	if battery_menu_instance:
		battery_menu_instance.queue_free()
		battery_menu_instance = null

func _position_menu_instance(menu_instance: Node) -> void:
	var camera = get_parent().get_node("Sprite2D/Camera")
	if camera and camera is Camera2D:
		var camera_center = camera.global_position
		var offset = Vector2(-50, -100)
		menu_instance.position = camera_center + offset
	else:
		print("Camera is not available. Defaulting to (0, 0).")
		menu_instance.position = Vector2.ZERO
