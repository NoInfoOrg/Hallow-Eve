extends CharacterBody2D

@export var inv: Inv
const SPEED = 300.0

# INFO: Assuming that Eve starts out facing to the front
var lastDirection : String = "S"

const PUSH_FORCE = 150.0

# INFO Sources:
# https://forum.godotengine.org/t/how-to-properly-change-the-sprite-depending-on-facing-direction-and-other-situations/19024
# https://forum.godotengine.org/t/how-do-i-change-sprite-texture-in-gdscript/51473

func _physics_process(delta):
	var direction = Input.get_vector("P1Left", "P1Right", "P1Up", "P1Down")
	velocity = direction * SPEED
	
	move_and_slide()
	
	## INFO U to open a door
	if Input.is_action_just_pressed("P1Grab"):
		check_to_open_door()
	
	# INFO Eve's Walking Animations (uses idle for placeholder)
	if Input.is_action_pressed("P1Left") and not (Input.is_action_pressed("P1Up") or Input.is_action_pressed("P1Down")):
		$AnimationPlayer.play("Eve_Idle_A")
		lastDirection = "A"
		check_box_collision(-PUSH_FORCE, 0, delta)
		
	elif Input.is_action_pressed("P1Right") and not (Input.is_action_pressed("P1Up") or Input.is_action_pressed("P1Down")):
		$AnimationPlayer.play("Eve_Idle_D")
		lastDirection = "D"
		check_box_collision(PUSH_FORCE, 0, delta)
		
	elif Input.is_action_pressed("P1Up") and not (Input.is_action_pressed("P1Left") or Input.is_action_pressed("P1Right")):
		$AnimationPlayer.play("Eve_Idle_W")
		lastDirection = "W"
		check_box_collision(0, -PUSH_FORCE, delta)
		
	elif Input.is_action_pressed("P1Down") and not (Input.is_action_pressed("P1Left") or Input.is_action_pressed("P1Right")):
		$AnimationPlayer.play("Eve_Idle_S")
		lastDirection = "S"
		check_box_collision(0, PUSH_FORCE, delta)
	
	# INFO meant to return animation to idle, but SHITS the debugger - Lizz
	# INFO I think this fixes it? But I don't know if this is what you had in mind - Nick
	elif velocity == Vector2.ZERO:
		$AnimationPlayer.play("Eve_Idle_" + lastDirection)
	
func check_box_collision(x_push, y_push, delta):
	for i in get_slide_collision_count():
		# Make sure Eve is actually moving in the direction she is pushing
		if y_push != 0 and (lastDirection == "A" or lastDirection == "D"):
			return
		elif x_push != 0 and (lastDirection == "W" or lastDirection == "S"):
			return
		
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		
		# Make sure that Eve is actually moving in the direction she is pushing
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
		
		# At this point, it should ideally be confirmed that Eve is moving to push the box
		if collision_box.is_in_group("Boxes") or collision_box.is_in_group("Spirit Boxes"):
			collision_box.push_by_player(Vector2(delta * x_push, delta * y_push), PUSH_FORCE)

func check_to_open_door():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var door = collision.get_collider()
		
		if door.is_in_group("Doors"):
			# Change the door image to be opened
			door.get_node("Door").play("open")
			
			# Change the door collision so players can enter the door
			door.get_node("Closed Door Collision").set_deferred("disabled", true)
