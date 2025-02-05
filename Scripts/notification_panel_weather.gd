extends Panel

# Signal emitted when wind speed exceeds 6 on the Beaufort scale
signal high_wind_alert

# Predefined weather conditions
var weather_conditions = ["Sunny", "Rainy", "Windy", "Showers", "Cloudy", "Stormy"]

# Timer for scheduling weather updates
var weather_timer = Timer.new()
# Random number generator
var rng = RandomNumberGenerator.new()
# Flag to ensure initialization runs only once
var is_initialized = false

func _ready():
	# Connect the visibility_changed signal to a handler
	connect("visibility_changed", Callable(self, "_on_visibility_changed"))

func _on_visibility_changed():
	# Check if the Panel is now visible and not yet initialized
	if is_visible_in_tree() and not is_initialized:
		is_initialized = true
		_initialize_script()

func _initialize_script():
	# Seed the random number generator
	rng.randomize()

	# Ensure ScrollContainer exists
	var scroll_container = $ScrollContainer
	if scroll_container == null:
		print("Error: ScrollContainer node not found.")
		return

	# Check if VBoxContainer exists; if not, create it
	var vbox = scroll_container.get_node_or_null("VBoxContainer")
	if vbox == null:
		vbox = VBoxContainer.new()
		vbox.name = "VBoxContainer"
		scroll_container.add_child(vbox)

	# Add timer to the scene
	add_child(weather_timer)

	# Configure weather timer (60 seconds interval)
	weather_timer.wait_time = 60.0
	weather_timer.connect("timeout", Callable(self, "_update_weather_notification"))
	weather_timer.start()

	# Initialize the first weather notification
	_update_weather_notification()
	
	# Create a button to display weather info in a pop-up
	var weather_info_button = Button.new()
	weather_info_button.name = "WeatherInfoButton"
	weather_info_button.text = "Show Weather Info"
	weather_info_button.connect("pressed", Callable(self, "_on_show_weather_popup"))
	# Add the button as the last child inside the VBoxContainer (so it appears at the bottom)
	vbox.add_child(weather_info_button)

func _update_weather_notification():
	# Select a random weather condition
	var weather = weather_conditions[rng.randi_range(0, weather_conditions.size() - 1)]

	# Generate random weather parameters
	var wind_speed = rng.randi_range(2, 12)  # Beaufort scale ranges from 0 to 12
	var wind_directions = ["North", "East", "South", "West"]
	var wind_direction = wind_directions[rng.randi_range(0, wind_directions.size() - 1)]
	var humidity = rng.randi_range(30, 100)  # Percentage
	var temperature = rng.randi_range(-10, 35)  # Celsius

	# Emit signal if wind speed exceeds 6 on the Beaufort scale
	if wind_speed > 6:
		emit_signal("high_wind_alert")

	# Access VBoxContainer
	var vbox = $ScrollContainer/VBoxContainer
	if vbox == null:
		print("Error: VBoxContainer node not found.")
		return

	# Format weather information text
	var weather_text = "Weather: %s\nWind Speed: %d Beaufort\nWind Direction: %s\nHumidity: %d%%\nTemperature: %d°C" % [weather, wind_speed, wind_direction, humidity, temperature]
	
	# Check if a weather notification already exists
	var weather_label = vbox.get_node_or_null("WeatherNotification")
	if weather_label:
		# Update existing weather notification
		weather_label.text = weather_text
	else:
		# Create a new weather notification
		weather_label = Label.new()
		weather_label.name = "WeatherNotification"
		weather_label.text = weather_text
		vbox.add_child(weather_label)
		# Apply theme overrides
		weather_label.add_theme_color_override("font_color", Color(0, 0, 0))
		weather_label.add_theme_font_size_override("font_size", 10)

func _on_show_weather_popup():
	# Retrieve the current weather information from the label
	var vbox = $ScrollContainer/VBoxContainer
	if vbox == null:
		print("Error: VBoxContainer node not found.")
		return
	
	var weather_label = vbox.get_node_or_null("WeatherNotification")
	var weather_text = ""
	if weather_label:
		weather_text = weather_label.text
	else:
		weather_text = "No weather information available."
	
	# Create and display a popup dialog with the weather info
	var popup = AcceptDialog.new()
	popup.dialog_text = weather_text
	add_child(popup)
	popup.popup_centered()
