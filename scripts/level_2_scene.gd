extends Node2D

var players_in_zone: Array[CharacterBody2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInformation.current_scene = "level_2_scene"
	GlobalInformation.music_scene = GlobalInformation.scenes.LEVEL_2
	GlobalInformation.change_music()

func _process(delta):
	change_scenes()


func _on_level_down_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = true
		players_in_zone.append(body)
		print("enter the zone")
		print(GlobalInformation.current_scene)


func _on_level_down_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = false
		players_in_zone.erase(body)

func change_scenes():
	if GlobalInformation.transition_scene == true:
		if GlobalInformation.current_scene == "level_2_scene" and len(players_in_zone) == 2:
			GlobalInformation.complete_change_scenes()
			get_tree().change_scene_to_file("res://scenes/level_3_scene.tscn")
