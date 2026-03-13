extends CharacterBody2D


const SPEED = 300.0

# INFO: Assuming that Willow starts out facing to the front
var lastDirection : String = "Down"

const PUSH_FORCE = 150.0

func _physics_process(delta):
	var direction = Input.get_vector("P2Left", "P2Right", "P2Up", "P2Down")
	velocity = direction * SPEED
	
	move_and_slide()
	
	## INFO P2Grab allows to open doors and press buttons
	if Input.is_action_just_pressed("P2Grab"):
		check_to_open_door()
	
	# INFO Willow's Walking Animations (uses idle for placeholder)
	if Input.is_action_pressed("P2Left") and not (Input.is_action_pressed("P2Up") or Input.is_action_pressed("P2Down")):
		$AnimationPlayer.play("Willow_Left")
		lastDirection = "Left"
		check_box_collision(-PUSH_FORCE, 0, delta)
		
	elif Input.is_action_pressed("P2Right") and not (Input.is_action_pressed("P2Up") or Input.is_action_pressed("P2Down")):
		$AnimationPlayer.play("Willow_Right")
		lastDirection = "Right"
		check_box_collision(PUSH_FORCE, 0, delta)
		
	elif Input.is_action_pressed("P2Up") and not (Input.is_action_pressed("P2Left") or Input.is_action_pressed("P2Right")):
		$AnimationPlayer.play("Willow_Up")
		lastDirection = "Up"
		check_box_collision(0, -PUSH_FORCE, delta)
		
	elif Input.is_action_pressed("P2Down") and not (Input.is_action_pressed("P2Left") or Input.is_action_pressed("P2Right")):
		$AnimationPlayer.play("Willow_Down")
		lastDirection = "Down"
		check_box_collision(0, PUSH_FORCE, delta)
		
	
	# INFO meant to return animation to idle, but SHITS the debugger - Lizz
	# INFO I think this fixes it? But I don't know if this is what you had in mind - Nick
	# elif velocity == Vector2.ZERO:
		# $AnimationPlayer.play("Willow_Idle_" + lastDirection)
	
func check_box_collision(x_push, y_push, delta):
	for i in get_slide_collision_count():
		# Make sure Willow is actually moving in the direction he is pushing
		if y_push != 0 and (lastDirection == "Left" or lastDirection == "Right"):
			return
		elif x_push != 0 and (lastDirection == "Up" or lastDirection == "Down"):
			return
		
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		
		# Make sure that Willow is actually moving in the direction she is pushing
		var normal = collision.get_normal()
		#print(normal)
		
		const LEFT_DIRECTION = Vector2(-1.0, 0.0)
		const RIGHT_DIRECTION = Vector2(1.0, 0.0)
		const UP_DIRECTION = Vector2(0.0, -1.0)
		const DOWN_DIRECTION = Vector2(0.0, 1.0)
		
		if x_push != 0 and (normal == UP_DIRECTION or normal == DOWN_DIRECTION):
			return
		elif x_push > 0 and normal == RIGHT_DIRECTION:
			return
		elif x_push < 0 and normal == LEFT_DIRECTION:
			return
		elif y_push != 0 and (normal == LEFT_DIRECTION or normal == RIGHT_DIRECTION):
			return
		elif y_push > 0 and normal == DOWN_DIRECTION:
			return
		elif y_push < 0 and normal == UP_DIRECTION:
			return
		
		# At this point, it should ideally be confirmed that Willow is moving to push the box
		if collision_box.is_in_group("Boxes") or collision_box.is_in_group("Human Boxes"):
			collision_box.push_by_player(Vector2(delta * x_push, delta * y_push), PUSH_FORCE)

func check_to_open_door():
	
	var inventory = get_node("../UI/SharedInv/Inventory")
	if inventory == null:
		print("danger type beat")
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var door = collision.get_collider()
		var door_verify = false
		for item in inventory.items:
			print(item.name)
			if item.name == "key":
				print("key :D")
				door_verify = true
		if door.is_in_group("Doors") and door_verify:
			# Only open doors that are not button-operated
			if door.synced_buttons_needed:
				return
			
			# Change the door image to be opened
			door.get_node("Door").play("open")
			
			# Change the door collision so players can enter the door
			door.get_node("Closed Door Collision").set_deferred("disabled", true)
