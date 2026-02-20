extends CharacterBody2D

const SPEED = 300.0
var lastDirection : String

# INFO Sources:
# https://forum.godotengine.org/t/how-to-properly-change-the-sprite-depending-on-facing-direction-and-other-situations/19024
# https://forum.godotengine.org/t/how-do-i-change-sprite-texture-in-gdscript/51473

func _physics_process(delta):
	var direction = Input.get_vector("P1Left", "P1Right", "P1Up", "P1Down")
	velocity = direction * SPEED
	
	move_and_slide()
	
	# INFO Eve's Walking Animations (uses idle for placeholder)
	if Input.is_action_just_pressed("P1Left") and not (Input.is_action_just_pressed("P1Up") or Input.is_action_just_pressed("P1Down")):
		$AnimationPlayer.play("Eve_Idle_A")
		lastDirection = "A"
	elif Input.is_action_just_pressed("P1Right") and not (Input.is_action_just_pressed("P1Up") or Input.is_action_just_pressed("P1Down")):
		$AnimationPlayer.play("Eve_Idle_D")
		lastDirection = "D"
	elif Input.is_action_just_pressed("P1Up") and not (Input.is_action_just_pressed("P1Left") or Input.is_action_just_pressed("P1Right")):
		$AnimationPlayer.play("Eve_Idle_W")
		lastDirection = "W"
	elif Input.is_action_just_pressed("P1Down") and not (Input.is_action_just_pressed("P1Left") or Input.is_action_just_pressed("P1Right")):
		$AnimationPlayer.play("Eve_Idle_S")
		lastDirection = "S"
	elif Input.is_action_just_pressed("P1Left") and Input.is_action_just_pressed("P1Up"):
		$AnimationPlayer.play("Eve_Idle_W+A")
		lastDirection = "W+A"
	elif Input.is_action_just_pressed("P1Left") and Input.is_action_just_pressed("P1Down"):
		$AnimationPlayer.play("Eve_Idle_A+S")
		lastDirection = "A+S"
	elif Input.is_action_just_pressed("P1Right") and Input.is_action_just_pressed("P1Up"):
		$AnimationPlayer.play("Eve_Idle_D+W")
		lastDirection = "D+W"
	elif Input.is_action_just_pressed("P1Right") and Input.is_action_just_pressed("P1Down"):
		$AnimationPlayer.play("Eve_Idle_S+D")
		lastDirection = "S+D"
	
	# INFO meant to return animation to idle, but SHITS the debugger - Lizz
	# elif velocity == Vector2.ZERO:
	#	$AnimationPlayer.play("Eve_Idle_" + lastDirection)
	
