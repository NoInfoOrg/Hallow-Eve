extends Node2D
@onready var ambience = get_node("Ambient Music")
@onready var scary = get_node("ScaryAmbience")
@onready var boss = get_node("Level1Boss")
@onready var boss_room = get_node("BossArea")
var current = null
var transitioning = false
var boss_music_played = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scary.volume_db = -80
	scary.play()
	boss.volume_db = -80
	boss.play()
	current = ambience

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("P1Grab"):
		lowkenuinelyTransition(current, scary)
		current = scary
		
	elif Input.is_action_just_pressed("P1Drop"):
		lowkenuinelyTransition(current, ambience)
		current = ambience
		
	if boss_room.boss_zone and not boss_music_played:
		boss_music_played = true
		lowkenuinelyTransition(current, boss)	
		current = boss
	if not boss_room.boss_zone and boss_music_played:
		lowkenuinelyTransition(current, scary)
		current = scary
		
func lowkenuinelyTransition(song1,song2):
		var tween = create_tween()
		tween.set_parallel(true)
		tween.set_ease(Tween.EASE_IN_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(song1, "volume_db", -80, 2.5)
		tween.tween_property(song2, "volume_db", 0, 2.5)
		await tween.finished
