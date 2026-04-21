extends Node2D
@onready var watch_light = get_node("Map/MovementCont/Eve - P1/watch_light")
var p1 : CharacterBody2D
var p2 : CharacterBody2D
var p1_ani : AnimationPlayer
var p2_ani : AnimationPlayer
var finished = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1 = get_node("Map/MovementCont/Eve - P1")
	p2 = get_node("Map/MovementCont/Willow - P2")
	p1_ani = get_node("Map/MovementCont/Eve - P1/AnimationPlayer")
	p2_ani = get_node("Map/MovementCont/Willow - P2/AnimationPlayer")
	p1.process_mode = Node.PROCESS_MODE_DISABLED
	p2.process_mode = Node.PROCESS_MODE_DISABLED
	p1_ani.process_mode = Node.PROCESS_MODE_ALWAYS
	p2_ani.process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("P1Drop"):
		pass
	
func watch_fizzles():
	var map = get_node("Map")
	var door  = get_node("Locked Doors/Tutorial-Hallway Door")
	map.visible = true
	if door:
		if door.has_node("ClosedDoor"):
			door.get_child(1).visible = false
			door.get_child(0).visible = true
			
	
	watch_light.fizzle_out()
	
func watch_fizzles2():
	var map = get_node("Map")
	var door  = get_node("Locked Doors/Tutorial-Hallway Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_child(0).visible = false
			door.get_child(1).visible = true
	map.visible = true
	watch_light.fizzle_out2()

func move_player(player: CharacterBody2D, end_pos : Vector2, time : float):
	# I do not have the Wilbert animations rn but you'd play like the low health one ig
	var map = get_node("Map")

	map.visible = true
	print("Moving Wilbert to pos ", end_pos, " he is currently at ", p2.global_position)
	var tweeny = create_tween()
	tweeny.set_trans(Tween.TRANS_LINEAR)
	tweeny.tween_property(player, "global_position", end_pos, time)
	await tweeny.finished

func willow_enters_with_sura():
	var map = get_node("Map")
	var door  = get_node("Locked Doors/Tutorial-Hallway Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_child(0).visible = false
			door.get_child(1).visible = true

	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Right_Walking")
	
	map.visible = true
	await move_player(p2,Vector2(600,350), 2)
	p2_ani.play("Willow_Right")
	await move_player(p1, Vector2(650, 350), .8)
	

func door_spook():
	var map = get_node("Map")
	p1.global_position = Vector2(650, 350)
	p2.global_position = Vector2(600,350)
	map.visible = true
	var door  = get_node("Locked Doors/Tutorial-Hallway Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = true
	shut_da_door()
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("")	

func shut_da_door():
	var doorClose = get_tree().current_scene.find_child("DoorClose", true, false)
	doorClose.play()
	
	
func wilbert_aura_loss():
	var map = get_node("Map")
	p1.global_position = Vector2(650, 350)
	p2.global_position = Vector2(600,350)
	map.visible = true
	var door  = get_node("Locked Doors/Tutorial-Hallway Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = true
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Left_Walking")
	await move_player(p2,Vector2(475,350), 1.2)
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Down_Walking")
	await move_player(p2,Vector2(475,700), 1.7)
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Down")
	
func door_opens_():
	var map = get_node("Map")
	p1.global_position = Vector2(650, 350)
	p2.global_position = Vector2(475, 650)
	map.visible = true
	var door  = get_node("Locked Doors/Tutorial-Hallway Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = false

func leave_tutorial():
	var map = get_node("Map")
	p1.global_position = Vector2(650, 350)
	p2.global_position = Vector2(475, 650)
	map.visible = true
	var door  = get_node("Locked Doors/Tutorial-Hallway Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = false
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Down_Walking")
	await move_player(p2,Vector2(475,900), 1.7)
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Down")
	$"Map/MovementCont/Eve - P1/AnimationPlayer".play("Eve_Walk_A")
	await move_player(p1, Vector2(475, 350), 1.3)
	$"Map/MovementCont/Eve - P1/AnimationPlayer".play("Eve_Walk_S")
	await move_player(p1, Vector2(475, 900), 2.3)
