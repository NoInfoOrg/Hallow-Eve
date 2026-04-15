extends Node2D


var players_in_zone: Array[CharacterBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInformation.music_scene = GlobalInformation.scenes.LEVEL_1
	GlobalInformation.change_music()

func _process(delta):
	change_scene()
	
# Switch to Level 2
func _on_level_down_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = true 
		players_in_zone.append(body)

func _on_level_down_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = false
		players_in_zone.erase(body)
		

func change_scene():
	if GlobalInformation.transition_scene == true:
		if GlobalInformation.current_scene == "level_1_scene" and len(players_in_zone) == 2:
			GlobalInformation.complete_change_scenes()
			get_tree().change_scene_to_file("res://scenes/level_2_scene.tscn")
