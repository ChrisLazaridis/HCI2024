extends Node2D

@onready var label = get_parent().get_node("Panel/Label")  # Absolute path to Label
@onready var top_left = get_parent().get_node("Top_Left")  # Absolute path to Top_Left
@onready var bottom_left = get_parent().get_node("Bottom Left")
@onready var popup_timer = Timer.new()  # Timer for delaying pop-up reminders
@onready var battery_timer = Timer.new()
@onready var light_button = get_parent().get_node("lights")
@onready var order_button = get_parent().get_node("order")
@onready var battery_button = get_parent().get_node("battery")
@onready var chat_button = get_parent().get_node("Chat")
@onready var battery_sprite = get_parent().get_node("battery/Sprite2D")
@onready var notification_panel= get_parent().get_node("NotificationPanelWeather")
@onready var notification_panel_2 = get_parent().get_node("NotificationPanelEvents")
@onready var battery_mode = "full"
@onready var top_left_data = null
@onready var bottom_left_data = null

@onready var notification_weather_panel = get_parent().get_node("NotificationPanelWeather")
var battery_levels = ["batteryempty.png", "battery30.png", "battery60l.png", "batteryfull.png"]
var current_level = 3  # Start at full battery
var popup_spawned = false  # Ensure the pop-up is only spawned once per runtime
var tarp_menu_instance = null  # Reference to the tarp placement menu instance

func _ready():
	# Verify node connections
	if not label:
		print("Error: Label node not found.")
		return
	if not top_left:
		print("Error: Top_Left node not found.")
		return
	if not bottom_left:
		print("Error: Bottom_Left node not found.")
		return
	light_button.set_visible(false)
	order_button.set_visible(false)
	battery_button.set_visible(false)
	notification_panel.set_visible(false)
	notification_panel_2.set_visible(false)
	chat_button.set_visible(false)

	# Connect signals
	top_left.connect("tent_placed", Callable(self, "_on_tent_placed"))
	bottom_left.connect("tent_placed", Callable(self, "_on_tent_placed"))
	top_left.connect("update_label", Callable(self, "_update_label"))
	bottom_left.connect("update_label", Callable(self, "_update_label"))
	battery_button.connect("battery_mode_selected", Callable(self, "_update_battery_mode"))
	

	# Setup the timer
	notification_weather_panel.connect("high_wind_alert", Callable(self, "_on_timer_timeout")) # Add the timer to the scene tree
	add_child(battery_timer)
	battery_timer.connect("timeout", Callable(self, "_on_battery_timer_timeout"))

func _update_label(data, emitter):
	if emitter == top_left:
		top_left_data = data
	elif emitter == bottom_left:
		bottom_left_data = data

	if top_left_data or bottom_left_data:
		var active_data = top_left_data if top_left_data else bottom_left_data
		label.text = "Humidity: %.2f%%\nSoil Stability: %.2f%%\nSolar Irradiance: %.2f W/m²" % [
		active_data["humidity"], active_data["soil_stability"], active_data["solar_irradiance"]
		]
		print("Updated label from", emitter, "with data:", data)
	elif label != null:
		label.text = ""

func _on_tent_placed():
	if popup_spawned:
		return  # Prevent multiple pop-ups
	popup_spawned = true
	light_button.set_visible(true)
	order_button.set_visible(true)
	battery_button.set_visible(true)
	notification_panel.set_visible(true)
	notification_panel_2.set_visible(true)
	chat_button.set_visible(true)
	var panel = get_parent().get_node("Panel")
	for child in panel.get_children():
		child.queue_free()
	panel.queue_free()
	var gps = get_parent().get_node("GPS")
	for child in gps.get_children():
		if child is Button:
			child.disabled = false

	# Start the timer with a random duration (e.g., 5-10 seconds)
	popup_timer.start(randi_range(5, 10))
	battery_timer.start(100)
	start_discharging()

func _on_timer_timeout():
	# Spawn the pop-up window
	var popup = preload("res://Scenes/pop_up_tarp.tscn").instantiate()
	add_child(popup)

	# Connect pop-up signals
	popup.connect("manual_selected", Callable(self, "_on_manual_selected"))
	popup.connect("automatic_selected", Callable(self, "_on_automatic_selected"))

func _on_manual_selected():
	print("Manual Placement Selected")
	# Spawn the tarp placement menu
	var tarp_menu_scene = preload("res://Scenes/tarp_placement_menu.tscn")
	tarp_menu_instance = tarp_menu_scene.instantiate()
	
	# Position the menu at the camera's center
	var camera = get_parent().get_node("Sprite2D/Camera")
	if camera and camera is Camera2D:
		var viewport_size = get_viewport().get_visible_rect().size
		var camera_center = camera.global_position
		var offset = Vector2(-50, -100)
		tarp_menu_instance.position = camera_center + offset
	else:
		print("Camera is not available. Defaulting to (0, 0).")
		tarp_menu_instance.position = Vector2.ZERO

	# Add the tarp menu to the scene tree
	get_tree().root.add_child(tarp_menu_instance)

	# Apply a vertical offset to the tarp and its sprite
	var tarp_node = tarp_menu_instance.get_node("minigame/tarp")  # Assuming "tarp" is the name of the node
	if tarp_node:
		tarp_node.position = Vector2(tarp_node.position.x, 70)  # Set Y position to 89
		var sprite = tarp_node.get_node("Sprite2D")  # Assuming the sprite is inside the tarp
		if sprite:
			sprite.position = tarp_node.position  # Sync the sprite with the tarp

	# Get the Manager node from the tarp menu
	var manager_node = tarp_menu_instance.get_node("Manager")

	# Connect the Manager's signals to handle confirmation and rejection
	manager_node.connect("scene_confirmed", Callable(self, "_on_tarp_menu_done"))
	manager_node.connect("scene_rejected", Callable(self, "_on_tarp_menu_rejected"))



func _on_automatic_selected():
	print("Automatic Placement Selected")
	# Mark the task as complete and stop the timer
	popup_spawned = true  # Prevent future pop-ups

func _on_tarp_menu_done():
	print("Tarp placement confirmed.")
	# Remove the tarp menu from the scene
	if tarp_menu_instance and tarp_menu_instance.get_parent():
		tarp_menu_instance.get_parent().remove_child(tarp_menu_instance)
	tarp_menu_instance = null  # Clear the reference

	# Prevent further pop-ups
	popup_spawned = true

func _on_tarp_menu_rejected():
	print("Tarp placement rejected. Restarting the timer.")
	# Remove the tarp menu from the scene
	if tarp_menu_instance and tarp_menu_instance.get_parent():
		tarp_menu_instance.get_parent().remove_child(tarp_menu_instance)
	tarp_menu_instance = null  # Clear the reference

	# Restart the reminder timer
	_restart_timer()
	
func _restart_timer():
	print("Restarting the reminder timer...")
	popup_spawned = false  # Allow the pop-up to spawn again
	# Restart the timer with a new random duration (e.g., 5-10 seconds)
	popup_timer.start(randi_range(5, 10))
	
func start_discharging():
	if battery_mode == "full":
		battery_timer.start(10)
	elif battery_mode == "moderate":
		battery_timer.start(25)
func start_charging():
	battery_mode = "save"
	battery_timer.start(30)
	
func _on_battery_timer_timeout():
	if battery_mode in ["full", "moderate"]:
		current_level -= 1
		if current_level < 0:
			current_level = 0
			battery_mode = "save"
			start_charging()
		else:
			update_battery_sprite()
			start_discharging()
	elif battery_mode == "save":
		current_level += 1
		if current_level > 3:
			current_level = 3
			battery_mode = "full"
			start_discharging()
		else:
			update_battery_sprite()
			start_charging()

func update_battery_sprite():
	var texture_path = "res://assets/battery/" + battery_levels[current_level]
	var new_texture = load(texture_path)
	if new_texture is Texture2D:
		battery_sprite.texture = new_texture
	else:
		print("Error: Loaded resource is not a Texture2D.")

func _update_battery_mode(mode):
	battery_mode = mode
	if battery_mode != "save":
		start_discharging()
	else:
		start_charging()
