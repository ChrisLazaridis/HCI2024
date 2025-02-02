extends OptionButton

# Declare a custom signal to emit when an item is selected
signal option_selected(selected_index: int)

@onready var label = get_node("Label")
# Called when the node enters the scene tree for the first time
func _ready():
	# Connect the 'item_selected' signal to the '_on_item_selected' function
	self.item_selected.connect(_on_item_selected)

# Function to handle the item selection
func _on_item_selected(index: int):
	# Emit the custom signal with the selected index
	emit_signal("option_selected", index)
	# Make the label invisible
	label.visible = false
