extends Panel
@onready var order_btn = get_parent().get_node("order")
# Predefined weather conditions and team events
var team_events = ["Football Match", "Pool Party", "Live Stage Event", "Team Meeting"]

# Timers for scheduling notifications
var event_timer = Timer.new()

func _ready():
	# Ensure ScrollContainer exists
	var scroll_container = $ScrollContainer
	if scroll_container == null:
		print("Error: ScrollContainer node not found.")
		return
	order_btn.connect("ordered", Callable(self, "_on_order"))

	# Check if VBoxContainer exists; if not, create it
	var vbox = scroll_container.get_node_or_null("VBoxContainer")
	if vbox == null:
		vbox = VBoxContainer.new()
		vbox.name = "VBoxContainer"
		scroll_container.add_child(vbox)

	# Add timers to the scene
	add_child(event_timer)


	# Configure event timer (random interval between 2 to 3 minutes)
	event_timer.wait_time = randi() % 60 + 120  # Random time between 120 to 180 seconds
	event_timer.connect("timeout", Callable(self, "_add_event_notification"))
	event_timer.start()
	_add_event_notification()




func _add_event_notification():
	# Select a random team event
	var event = team_events[randi() % team_events.size()]

	# Access VBoxContainer
	var vbox = $ScrollContainer/VBoxContainer
	if vbox == null:
		print("Error: VBoxContainer node not found.")
		return

	# Create a container for the event notification
	var event_hbox = HBoxContainer.new()
	event_hbox.name = "EventNotification"

	# Create and add the event label
	var event_label = Label.new()
	event_label.text = "Event: " + event
	event_hbox.add_child(event_label)
	# Apply theme overrides
	event_label.add_theme_color_override("font_color", Color(0, 0, 0))
	event_label.add_theme_font_size_override("font_size", 8)

	# Create and add the Accept button
	var accept_button = Button.new()
	accept_button.text = "✓"
	accept_button.connect("pressed", Callable(self, "_remove_notification").bind(event_hbox))
	event_hbox.add_child(accept_button)

	# Create and add the Dismiss button
	var dismiss_button = Button.new()
	dismiss_button.text = "𐄂"
	dismiss_button.connect("pressed", Callable(self, "_remove_notification").bind(event_hbox))
	event_hbox.add_child(dismiss_button)

	# Add the event notification to the VBoxContainer
	vbox.add_child(event_hbox)

	# Restart the event timer with a new random interval between 2 to 3 minutes
	event_timer.stop()
	event_timer.wait_time = randi() % 60 + 120
	event_timer.start()

func _remove_notification(notification):
	# Remove the specified notification from the VBoxContainer
	var vbox = $ScrollContainer/VBoxContainer
	if vbox:
		vbox.remove_child(notification)
	notification.queue_free()

func _on_order():
	await get_tree().create_timer(20.0).timeout

	var vbox = $ScrollContainer/VBoxContainer
	if vbox == null:
		print("Error: VBoxContainer node not found.")
		return

	# Create a container for the order notification
	var event_hbox = HBoxContainer.new()
	event_hbox.name = "OrderNotification"

	# Create and add the order label
	var order_label = Label.new()
	order_label.text = "Your order is ready"
	event_hbox.add_child(order_label)
	# Apply theme overrides
	order_label.add_theme_color_override("font_color", Color(0, 0, 0))
	order_label.add_theme_font_size_override("font_size", 8)

	# Create and add the Accept button
	var accept_button = Button.new()
	accept_button.text = "✓"
	accept_button.connect("pressed", Callable(self, "_remove_notification").bind(event_hbox))
	event_hbox.add_child(accept_button)


	# Add the event notification to the VBoxContainer
	vbox.add_child(event_hbox)
