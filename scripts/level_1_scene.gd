extends Node2D

var players_in_zone: Array[CharacterBody2D] = []
@onready var status_label = $LevelChangeLabel/WaitingForPlayerLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInformation.current_scene = "level_1_scene"
	GlobalInformation.music_scene = GlobalInformation.scenes.LEVEL_1
	GlobalInformation.change_music()

func _process(delta):
	change_scene()
	if status_label.text != "":
		status_label.position.y = (get_viewport_rect().size.y - 80) + (sin(Time.get_ticks_msec() * 0.005) * 5)
	else:
		status_label.position.y = -200

# Switch to Level 2
func _on_level_down_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = true
		players_in_zone.append(body)
		display_waiting_label()

# detects when player exits level down zone
func _on_level_down_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = false
		players_in_zone.erase(body)
		display_waiting_label()
		
# changes scene
func change_scene():
	if GlobalInformation.transition_scene == true:
		if GlobalInformation.current_scene == "level_1_scene" and len(players_in_zone) == 2:
			GlobalInformation.complete_change_scenes()
			get_tree().change_scene_to_file("res://scenes/level_2_scene.tscn")

# displays waiting for player label to players
func display_waiting_label():
	match players_in_zone.size():
		0:
			status_label.text = ""
		1:
			var player_name = players_in_zone[0].name
			if "1" in player_name:
				status_label.text = "Waiting for P2..."
			else:
				status_label.text = "Waiting for P1..."
		2:
			status_label.text = "LETS GOOOO"
