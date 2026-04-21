extends Node2D
var p1 : CharacterBody2D
var p2 : CharacterBody2D
var p1_ani : AnimationPlayer
var p2_ani : AnimationPlayer
var ben_ani : AnimationPlayer
var ben : CharacterBody2D

# Called when the node enters the scene tree for the first time.
var finished = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p1 = get_node("Map/MovementCont/Eve - P1")
	p2 = get_node("Map/MovementCont/Willow - P2")
	p1_ani = get_node("Map/MovementCont/Eve - P1/AnimationPlayer")
	p2_ani = get_node("Map/MovementCont/Willow - P2/AnimationPlayer")
	ben_ani = get_node("Map/MovementCont/BlanketBen/AnimationPlayer")
	ben = get_node("Map/MovementCont/BlanketBen")
	p1.process_mode = Node.PROCESS_MODE_DISABLED
	p2.process_mode = Node.PROCESS_MODE_DISABLED
	p1_ani.process_mode = Node.PROCESS_MODE_ALWAYS
	p2_ani.process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("P1Drop"):
		boss_win()
# [Sleepless child meanders about the halls sporadically]
func enter_room():
	var door = get_node("Locked Doors/Bathroom-SleeplessChildRoom Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = false
	$Map/MovementCont/BlanketBen.scale = Vector2(-.5, .5)
	$Map/MovementCont/BlanketBen/AnimationPlayer.play("Blankie_Walk_Left")
	await move_player(ben, Vector2(600, 433), 2.5)
	$Map/MovementCont/BlanketBen/AnimationPlayer.play("Blankie_Walk_Right")
	await move_player(ben, Vector2(992, 433), 2.5)		
	$Map/MovementCont/BlanketBen/AnimationPlayer.play("Blankie_Idle_Right")
	
func move_player(player: CharacterBody2D, end_pos : Vector2, time : float):
	# I do not have the Wilbert animations rn but you'd play like the low health one ig
	var map = get_node("Map")
	map.visible = true
	print("Moving ", player,"  to pos ", end_pos, " he is currently at ", player.global_position)
	var tweeny = create_tween()
	tweeny.set_trans(Tween.TRANS_LINEAR)
	tweeny.tween_property(player, "global_position", end_pos, time)
	await tweeny.finished
			
# [Lights flicker on and off, Willow is clearly freaked out]
func lights_flicker():
	var door = get_node("Locked Doors/Bathroom-SleeplessChildRoom Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = false
	var lights = []
	var light1 = get_node("PointLight2D")
	
	var light2 = get_node("PointLight2D2")
	var light3 = get_node("PointLight2D3")
	var light4 = get_node("PointLight2D4")
	lights.append(light1)
	lights.append(light2)
	lights.append(light3)
	lights.append(light4)
	for light in lights:
		light_tween(light)


func light_tween(light):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(light, "energy", 0.4, .1)
	tween.tween_property(light, "energy", 0.8, .1)
	tween.tween_property(light, "energy", 0.5, .2)
	tween.tween_property(light, "energy", 2, .1)
	tween.tween_property(light, "energy", .5, .1)
	tween.tween_property(light, "energy", 5, .1)
	tween.tween_property(light, "energy", .75, .1)
	tween.tween_property(light, "energy", 7, .1)
	tween.tween_property(light, "energy", 0, .1)
	tween.tween_property(light, "energy", 8.5, .1)
	await tween.finished
	
# Willow attempts to get the key on the Sleepless Child’s bed, and is pushed away]
func willow_gets_pushed():
	var door = get_node("Locked Doors/Bathroom-SleeplessChildRoom Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = false
	ben.global_position = Vector2(992, 433)
	p1.global_position = Vector2(1050, -150)
	
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Down_Walking")
	$"Map/MovementCont/Willow - P2".z_index = 6
	await move_player(p2, Vector2(1049, 400), 3)
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Left")
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Right")
	await move_player(ben, Vector2(275, 375), 2)

	var ani_player = $"Map/MovementCont/Willow - P2"/AnimationPlayer
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Sleep")
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Left_Walking")
	await move_player(p2, Vector2(400, 400), 3)
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Left_PickUp")
	var ani_length = $"Map/MovementCont/Willow - P2"/AnimationPlayer.get_animation("Willow_Left_PickUp").length
	await get_tree().create_timer(ani_length).timeout
	ani_player.stop()
	$"Map/MovementCont/Eve - P1"/AnimationPlayer.play("Eve_Walk_S")
	await move_player(p1, Vector2(1050, 350), 5)
	$"Map/MovementCont/Eve - P1"/AnimationPlayer.play("Eve_Idle_A")
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Right_Walking")
	await move_player(p2, Vector2(900, 400), 5)
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Left")
# [Sleepless Child, once agitated, and near an outlet, accidentally plugs it’s tail in]
func agitated_to_sleep():
	var door = get_node("Locked Doors/Bathroom-SleeplessChildRoom Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = false
	ben.global_position = Vector2(992, 433)
	p1.global_position = Vector2(1050, 350)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Right")	
	p2.global_position = Vector2(900, 400)
	
	await move_player(ben, Vector2(600, 400), 2)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Left")	
	await move_player(ben, Vector2(992, 400), 2)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Right")
	
	await move_player(ben, Vector2(750, 350), 2)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Left")
	await move_player(ben, Vector2(800, 350), 2)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Sleep")
	# im combining these two, it only makes sense
	await get_tree().create_timer(1).timeout
	
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Down_Walking")
	await move_player(p2, Vector2(900, 650), 2)
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Up")
	$"Map/MovementCont/Eve - P1/AnimationPlayer".play("Eve_Walk_S")
	await move_player(p1, Vector2(1050, 600), 2)
	$"Map/MovementCont/Eve - P1/AnimationPlayer".play("Eve_Idle_W")
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Right")
	await move_player(ben, Vector2(300, 400), 2)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Left")
	await move_player(ben, Vector2(900, 400), 2)
# [Sleepless Child is tempered and Willow can finally grab the key from the bed. After, the Child lays down on the bed and disappears, becoming the blanket]
func boss_win():
	var door = get_node("Locked Doors/Bathroom-SleeplessChildRoom Door")
	if door:
		if door.has_node("OpenDoor"):
			door.get_node("ClosedDoor").visible = false
	$"Map/MovementCont/Eve - P1/AnimationPlayer".play("Eve_Idle_W")
	$"Map/MovementCont/Willow - P2/AnimationPlayer".play("Willow_Up")
	p1.global_position = Vector2(1050, 600)
	p2.global_position = Vector2(900, 650)
	p2.z_index = 4
	ben.global_position = Vector2(992, 433)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Right")
	
	await move_player(ben, Vector2(750, 350), 2)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Agitated_Left")
	await move_player(ben, Vector2(800, 350), 2)
	$"Map/MovementCont/BlanketBen"/AnimationPlayer.play("Blankie_Sleep")
	# [Willow walks out from the room and Eve follows] (imma have the key grab here)
	var key = get_node("Assets/SleeplessChildRoom/Key")
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Up_Walking")
	await move_player(p2, Vector2(900, 450), 2)
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Left_Walking")
	await move_player(p2, Vector2(450, 450), 2)
	var ani_player = $"Map/MovementCont/Willow - P2"/AnimationPlayer
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Left_PickUp")
	var ani_length = $"Map/MovementCont/Willow - P2"/AnimationPlayer.get_animation("Willow_Left_PickUp").length
	await get_tree().create_timer(ani_length).timeout
	ani_player.stop()
	key.visible = false
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Right_Walking")
	await move_player(p2, Vector2(1000, 450), 2)
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Up_Walking")
	await move_player(p2, Vector2(1000, 100), 2)
	$"Map/MovementCont/Willow - P2"/AnimationPlayer.play("Willow_Up")
	$"Map/MovementCont/Eve - P1/AnimationPlayer".play("Eve_Walk_W")
	await move_player(p1, Vector2(1050, 100), 5)
	$"Map/MovementCont/Eve - P1/AnimationPlayer".play("Eve_Idle_W")
