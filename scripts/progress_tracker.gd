extends Node2D

var empty_texture = preload("res://assets/ui elements/Clock-Progression_Empty.png")
var morning_texture = preload("res://assets/ui elements/Clock-Progression_Morning.png")
var noon_texture = preload("res://assets/ui elements/Clock-Progression_Noon.png")
var evening_texture = preload("res://assets/ui elements/Clock-Progression_Evening.png")
var night_texture = preload("res://assets/ui elements/Clock-Progression_Night.png")

var previous_texture = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var progress_tracker_sprite = get_node("TextureRect")
	
	if previous_texture == null or previous_texture != progress_tracker_sprite.texture:
		if GlobalInformation.current_scene == "level_1_scene":
			progress_tracker_sprite.texture = morning_texture
			
		elif GlobalInformation.current_scene == "level_2_scene":
			progress_tracker_sprite.texture = noon_texture
			
		elif GlobalInformation.current_scene == "level_3_scene":
			progress_tracker_sprite.texture = evening_texture
