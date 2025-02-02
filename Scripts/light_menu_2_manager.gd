extends Control

@onready var confirm_button: Button = get_node("Panel/Confirm")
@onready var reject_button: Button = get_node("Panel/Reject")
@onready var colors_preview: Array = []
@onready var color_picked: Color = Color()
@onready var effect: String = "static"
@onready var brightness: float = 100.0
@onready var slider: HSlider = get_node("HSlider")
@onready var effect_button: OptionButton = get_node("OptionButton")
@onready var color_button: ColorPickerButton = get_node("ColorPickerButton")

signal selected_color(color: Color, effect: String, brightness: float)
signal rejected_lights

var breathing_timer: float = 0.0
var breathing_direction: int = 1 # 1 for increasing, -1 for decreasing

func _ready() -> void:
	var color_preview_container = get_node("ColorPreview")
	for child in color_preview_container.get_children():
		if child is ColorRect:
			colors_preview.append(child)
	slider.connect("value_changed", Callable(self, "_brightness_value_changed"))
	effect_button.connect("item_selected", Callable(self, "_effect_value_change"))
	color_button.connect("color_changed", Callable(self, "_on_color_changed"))
	confirm_button.connect("pressed", Callable(self, "_on_confirm"))
	reject_button.connect("pressed", Callable(self, "_on_reject"))

func _brightness_value_changed(value: float) -> void:
	brightness = value

func _process(delta: float) -> void:
	if effect == "breathing":
		_breathing_effect(delta)
	else:
		_apply_static_brightness()

func _breathing_effect(delta: float) -> void:
	breathing_timer += delta * 0.5 * breathing_direction
	if breathing_timer > 1.0:
		breathing_timer = 1.0
		breathing_direction = -1
	elif breathing_timer < 0.0:
		breathing_timer = 0.0
		breathing_direction = 1

	var adjusted_brightness = brightness * (breathing_timer * 0.5 + 0.5) / 100.0
	for c in colors_preview:
		c.color = color_picked.lerp(Color(0, 0, 0), 1.0 - adjusted_brightness)

func _apply_static_brightness() -> void:
	var adjusted_brightness = brightness / 100.0
	for c in colors_preview:
		c.color = color_picked.lerp(Color(0, 0, 0), 1.0 - adjusted_brightness)

func _effect_value_change(index: int) -> void:
	match index:
		0:
			effect = "static"
		1:
			effect = "breathing"
		_:
			effect = "static"

func _on_color_changed(color: Color) -> void:
	color_picked = color
	if effect == "static":
		_apply_static_brightness()

func _on_confirm() -> void:
	emit_signal("selected_color", color_picked, effect, brightness)

func _on_reject() -> void:
	emit_signal("rejected_lights")
