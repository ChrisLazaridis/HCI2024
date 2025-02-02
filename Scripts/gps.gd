extends Control

@onready var shelter_btn = get_node("Shelter")
@onready var football_btn = get_node("Football")
@onready var pool_btn = get_node("Pool")
@onready var stage_btn = get_node("Stage")
@onready var gps_football = get_node("GuideToFootball")
@onready var gps_shelter = get_node("GuideToShelter")
@onready var gps_pool = get_node("GuideToPool")
@onready var gps_stage = get_node("GuideToStage")
@onready var gps_shared = get_node("SharedGuide")

func _ready() -> void:
	# Connect button signals
	shelter_btn.connect("pressed", Callable(self, "_guide_to_shelter"))
	football_btn.connect("pressed", Callable(self, "_guide_to_football"))
	pool_btn.connect("pressed", Callable(self, "_guide_to_pool"))
	stage_btn.connect("pressed", Callable(self, "_guide_to_stage"))

	# Initialize all guides
	_initialize_guides()

func _initialize_guides() -> void:
	var guides = [gps_shared, gps_shelter, gps_football, gps_pool, gps_stage]
	for guide in guides:
		if guide:
			for child in guide.get_children():
				if child is ColorRect:
					child.modulate = Color(0.0, 0.7, 1.0, 0.5)
					child.visible = false

func _reset_guides() -> void:
	var guides = [gps_shared, gps_shelter, gps_football, gps_pool, gps_stage]
	for guide in guides:
		if guide:
			for child in guide.get_children():
				if child is ColorRect:
					child.visible = false

func _guide_to_shelter() -> void:
	_reset_guides()
	_show_guide(gps_shelter)
	_show_guide(gps_shared)
	

func _guide_to_football() -> void:
	_reset_guides()
	_show_guide(gps_shared)
	_show_guide(gps_football)

func _guide_to_pool() -> void:
	_reset_guides()
	_show_guide(gps_shared)
	_show_guide(gps_pool)

func _guide_to_stage() -> void:
	_reset_guides()
	_show_guide(gps_shared)
	_show_guide(gps_stage)

func _show_guide(guide: Node) -> void:
	if guide:
		for child in guide.get_children():
			if child is ColorRect:
				child.visible = true
