extends Control

@onready var label_valid = get_parent().get_node("Manager/Label_Valid")  # Adjusted path for the Label node
@onready var label_invalid = get_parent().get_node("Manager/Label_Invalid")
@onready var confirm_button = get_parent().get_node("Panel/confirm")  # Adjusted path for the ConfirmButton
@onready var reject_button = get_parent().get_node("Panel/reject")  # Adjusted path for the RejectButton

signal scene_confirmed  # Signal to notify the main game that confirm was pressed
signal scene_rejected  # Signal to notify the main game that reject was pressed

var is_tarp_valid = false  # Track the tarp's validity

func _ready():
	# Get the tarp node explicitly from the hierarchy
	var tarp_node = get_parent().get_node("minigame/tarp") # Adjusted path for the Tarp node
	label_invalid.set_visible(false)
	label_invalid.set_visible(false) 

	# Connect signals from the tarp node
	if tarp_node.has_signal("placement_valid"):
		print("validsignal connected")
		tarp_node.connect("placement_valid", Callable(self, "_on_tarp_placement_valid"))
	if tarp_node.has_signal("placement_invalid"):
		print("invalid signal connected")
		tarp_node.connect("placement_invalid", Callable(self, "_on_tarp_placement_invalid"))

	# Connect signals from buttons
	confirm_button.connect("confirm_pressed", Callable(self, "_on_confirm_pressed"))
	reject_button.connect("reject_pressed", Callable(self, "_on_reject_pressed"))

func _on_tarp_placement_valid():
	label_valid.set_visible(true)
	label_invalid.set_visible(false)
	is_tarp_valid = true  # Update validity status

func _on_tarp_placement_invalid():
	label_valid.set_visible(false)
	label_invalid.set_visible(true)
	is_tarp_valid = false  # Update validity status

func _on_confirm_pressed():
	if is_tarp_valid:
		print("Confirmation accepted!")
		emit_signal("scene_confirmed")  # Notify the main game
	else:
		print("Cannot confirm: Tarp placement invalid!")

func _on_reject_pressed():
	print("Confirmation rejected!")
	emit_signal("scene_rejected")  # Notify the main game
