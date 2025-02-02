extends Control

@onready var input_field: LineEdit = $Panel/LineEdit
@onready var send_button: Button = $Panel/Send
@onready var chat_container: VBoxContainer = $Panel/ScrollContainer/VBoxContainer
@onready var nobodywho_chat: NobodyWhoChat = $NobodyWhoChat

var typing_panel: PanelContainer = null
var typing_timer: Timer = null
var typing_label: Label = null  # Reference to the typing label

func _ready() -> void:
	# Connect signals
	nobodywho_chat.connect("response_updated", Callable(self, "_on_response_updated"))
	nobodywho_chat.connect("response_finished", Callable(self, "_on_response_finished"))
	send_button.pressed.connect(_on_send_button_pressed)
	
	# Start the LLM worker
	nobodywho_chat.start_worker()

func _on_send_button_pressed() -> void:
	var user_message = input_field.text.strip_edges()
	if user_message != "":
		_add_message(user_message, true)
		input_field.clear()
		_add_typing_indicator()  # Show typing indicator
		nobodywho_chat.say(user_message)  # Send user message to the LLM

func _on_response_updated(token: String) -> void:
	# Handle streaming responses token by token (optional)
	pass

func _on_response_finished(response: String) -> void:
	_remove_typing_indicator()  # Remove typing indicator
	_add_message(response, false)  # Display the model's response

func _add_message(message: String, is_user: bool) -> void:
	var message_panel = PanelContainer.new()
	var message_label = Label.new()
	message_label.text = message
	message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART  # Enable word wrapping
	message_label.horizontal_alignment = 2 if is_user else 0
	message_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Allow the label to expand horizontally

	var timestamp_label = Label.new()
	timestamp_label.text = _get_current_timestamp()
	timestamp_label.horizontal_alignment = 0 if is_user else 2
	timestamp_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	timestamp_label.modulate = Color(0.5, 0.5, 0.5)  # Gray color for timestamp

	var message_vbox = VBoxContainer.new()
	message_vbox.add_child(message_label)
	message_vbox.add_child(timestamp_label)
	message_panel.add_child(message_vbox)

	message_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Allow the panel to expand horizontally
	message_panel.custom_minimum_size = Vector2(360, 0)  # Set a minimum width for the message panel
	chat_container.add_child(message_panel)
	chat_container.move_child(message_panel, chat_container.get_child_count() - 1)  # Add to the bottom

	# Load the theme resource
	var theme = load("res://assets/kenneyUI-blue.tres")
	if theme:
		# Apply the theme to the message panel
		message_panel.add_theme_stylebox_override("panel", theme.get_stylebox("panel", "PanelContainer"))
	else:
		# If the theme fails to load, create a default StyleBoxFlat
		var default_stylebox = StyleBoxFlat.new()
		default_stylebox.bg_color = Color(0.8, 0.8, 1) if is_user else Color(0.8, 1, 0.8)  # Light blue for user, light green for bot
		message_panel.add_theme_stylebox_override("panel", default_stylebox)

func _add_typing_indicator() -> void:
	typing_panel = PanelContainer.new()
	typing_label = Label.new()
	typing_label.text = "Typing"
	typing_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	typing_label.horizontal_alignment = 0  # Align left
	typing_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	typing_panel.add_child(typing_label)
	typing_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	typing_panel.custom_minimum_size = Vector2(200, 0)
	chat_container.add_child(typing_panel)
	chat_container.move_child(typing_panel, chat_container.get_child_count() - 1)

	# Start the typing animation
	_start_typing_animation()

func _start_typing_animation() -> void:
	typing_timer = Timer.new()
	typing_timer.wait_time = 0.5  # Interval between dot additions
	typing_timer.autostart = true
	typing_timer.one_shot = false
	typing_timer.connect("timeout", Callable(self, "_on_typing_timer_timeout"))
	add_child(typing_timer)

func _on_typing_timer_timeout() -> void:
	if typing_label:
		var dot_count = typing_label.text.count(".")
		if dot_count < 3:
			typing_label.text += "."
		else:
			typing_label.text = "Typing"

func _remove_typing_indicator() -> void:
	if typing_panel and typing_panel.is_inside_tree():
		typing_panel.queue_free()
		typing_panel = null
	if typing_timer and typing_timer.is_inside_tree():
		typing_timer.queue_free()
		typing_timer = null
	typing_label = null

func _get_current_timestamp() -> String:
	var unix_time = Time.get_unix_time_from_system()
	var datetime_dict = Time.get_datetime_dict_from_unix_time(unix_time)
	return "%02d:%02d" % [datetime_dict.hour+2, datetime_dict.minute]
