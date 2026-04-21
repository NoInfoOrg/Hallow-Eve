extends Node2D

var players_in_zone: Array[CharacterBody2D] = []
@onready var status_label = $%LevelChangeLabel/WaitingForPlayerLabel

@onready var ambience = get_tree().current_scene.find_child("Ambient Music", true, false)
@onready var scary = get_tree().current_scene.find_child("ScaryAmbience", true, false)
@onready var boss = get_tree().current_scene.find_child("Level2Boss", true, false)
@onready var boss_room = get_tree().current_scene.find_child("BossArea", true, false)

var current = null
var transitioning = false
var boss_music_played = false

func lowkenuinelyTransition(song1,song2):
	transitioning = true
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(song1, "volume_db", -80, 2.5)
	tween.tween_property(song2, "volume_db", 0, 2.5)
	await tween.finished
	transitioning = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInformation.current_scene = "level_2_scene"
	GlobalInformation.music_scene = GlobalInformation.scenes.LEVEL_2
	#GlobalInformation.change_music()
	scary.volume_db = -80
	scary.play()
	boss.volume_db = -80
	boss.play()
	current = ambience

func _process(delta):
	change_scenes()
	if status_label.text != "":
		status_label.position.y = (get_viewport_rect().size.y - 80) + (sin(Time.get_ticks_msec() * 0.005) * 5)
	else:
		status_label.position.y = -200
	if transitioning:
		return
	if Input.is_action_just_pressed("P1Grab"):
		await lowkenuinelyTransition(current, scary)
		current = scary
		
	elif Input.is_action_just_pressed("P1Drop"):
		await lowkenuinelyTransition(current, ambience)
		current = ambience
		
	if boss_room.boss_zone and not boss_music_played:
		boss_music_played = true
		await lowkenuinelyTransition(current, boss)	
		current = boss
	if boss_music_played and not boss_room.boss_zone:
		await lowkenuinelyTransition(boss, scary)
		current = scary


func _on_level_down_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = true
		players_in_zone.append(body)
		display_waiting_label()


func _on_level_down_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("Players"):
		GlobalInformation.transition_scene = false
		players_in_zone.erase(body)
		display_waiting_label()

func change_scenes():
	if GlobalInformation.transition_scene == true:
		if GlobalInformation.current_scene == "level_2_scene" and len(players_in_zone) == 2:
			GlobalInformation.complete_change_scenes()
			get_tree().change_scene_to_file("res://scenes/level_3_scene.tscn")

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
