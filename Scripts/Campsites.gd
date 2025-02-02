extends Area2D

# Signal to notify when the label should be updated
signal update_label(data, emitter)
signal tent_placed

# Array to store child data
var child_data = []

# Define ranges for random values
@export var humidity_range = Vector2(0, 100)
@export var soil_stability_range = Vector2(0, 100)
@export var solar_irradiance_range = Vector2(100, 1000)

# Path to the tent texture
@export var tent_texture_path = "res://assets/Tents/TENT_black.png"
@export var picket_nailing_menu_instance: Node = null


# Store the last clicked grid
var last_clicked_grid = null

func _ready():
	# Assign random values to each CollisionShape2D child and add buttons
	for child in get_children():
		if child is CollisionShape2D:
			# Assign random data
			var data = {
				"humidity": randf_range(humidity_range.x, humidity_range.y),
				"soil_stability": randf_range(soil_stability_range.x, soil_stability_range.y),
				"solar_irradiance": randf_range(solar_irradiance_range.x, solar_irradiance_range.y),
			}
			child_data.append(data)
			child.set_meta("data", data)

			# Create an invisible button to overlay the CollisionShape2D
			var button = Button.new()
			button.text = ""  # No visible text
			button.set_custom_minimum_size(Vector2(child.shape.extents.x * 2, child.shape.extents.y * 2))
			button.position = -child.shape.extents
			button.flat = true

			# Add button to the child
			child.add_child(button)

			# Use a lambda function for the button click handling
			button.connect("pressed", Callable(self, "_on_grid_clicked").bind(child))

	# Enable process to track mouse movement
	set_process(true)

func _process(delta):
	var mouse_pos = get_global_mouse_position()
	for child in get_children():
		if child is CollisionShape2D:
			if is_point_in_shape(child, mouse_pos):
				var data = child.get_meta("data")
				if data:
					emit_signal("update_label", data, self)
				return
	# If no grid is hovered, send a signal to clear the label
	emit_signal("update_label", null, self)

# Helper function to check if a point is inside a CollisionShape2D
func is_point_in_shape(shape: CollisionShape2D, point: Vector2) -> bool:
	if shape.shape:
		var local_point = shape.to_local(point)
		if shape.shape is RectangleShape2D:
			return shape.shape.extents.x > abs(local_point.x) and shape.shape.extents.y > abs(local_point.y)
		elif shape.shape is CircleShape2D:
			return local_point.length() <= shape.shape.radius
		elif shape.shape is ConvexPolygonShape2D:
			return shape.shape.is_point_inside(local_point)
	return false

# Handle grid clicks
func _on_grid_clicked(grid_child):
	last_clicked_grid = grid_child
	_open_picket_nailing_menu()

# Open the picket nailing menu
func _open_picket_nailing_menu():
	var picket_nailing_menu_scene = load("res://Scenes/picket_nailing_menu.tscn")
	var camera = get_parent().get_node("Sprite2D/Camera")
	if picket_nailing_menu_scene is PackedScene:
		picket_nailing_menu_instance = picket_nailing_menu_scene.instantiate()
		
		# Calculate the center of the camera
		if camera and camera is Camera2D:
			var viewport_size = get_viewport().get_visible_rect().size
			var camera_center = camera.global_position
			var offset = Vector2(-50, -100)
			picket_nailing_menu_instance.position = camera_center + offset
		else:
			print("Camera is not available. Defaulting to (0, 0).")
			picket_nailing_menu_instance.position = Vector2.ZERO

		# Connect signals
		picket_nailing_menu_instance.get_node("Panel/confirm").connect("pickets_placed", Callable(self, "_on_pickets_placed"))
		picket_nailing_menu_instance.get_node("Panel/reject").connect("pickets_rejected", Callable(self, "_on_pickets_rejected"))
		
		# Add the instance to the current scene
		get_tree().root.add_child(picket_nailing_menu_instance)
	else:
		push_error("Loaded resource is not a PackedScene!")

# Handle the signal for pickets placed
func _on_pickets_placed():
	if picket_nailing_menu_instance:
		if picket_nailing_menu_instance.get_parent():
			picket_nailing_menu_instance.get_parent().remove_child(picket_nailing_menu_instance)
		picket_nailing_menu_instance = null  # Clear the reference

	if last_clicked_grid:
		# Remove all grids
		for child in get_parent().get_node("Bottom Left").get_children():
			if child is CollisionShape2D:
				child.queue_free()
		for child in get_parent().get_node("Top_Left").get_children():
			if child is CollisionShape2D:
				child.queue_free()
		# Place the tent at the last clicked grid's position
		var tent = Sprite2D.new()
		tent.texture = load(tent_texture_path)
		tent.position = last_clicked_grid.global_position
		tent.name = "tent"
		add_child(tent)
		print(tent.get_path())
		emit_signal("tent_placed")

func _on_pickets_rejected():
	# Find the picket_nailing_menu_instance node and remove it from the tree
	if picket_nailing_menu_instance:
		if picket_nailing_menu_instance.get_parent():
			picket_nailing_menu_instance.get_parent().remove_child(picket_nailing_menu_instance)
		picket_nailing_menu_instance = null  # Clear the reference
	print("User rejected the placement of the tent.")
