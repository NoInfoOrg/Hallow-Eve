extends CharacterBody2D


const SPEED = 300.0

# INFO Sources:
# https://forum.godotengine.org/t/how-to-properly-change-the-sprite-depending-on-facing-direction-and-other-situations/19024
# https://forum.godotengine.org/t/how-do-i-change-sprite-texture-in-gdscript/51473

# INFO Textures for Eve facing different directions
var eve_0_degrees = preload("res://assets/sprites/p1/Eve 0 Deg.png")
var eve_45_degrees = preload("res://assets/sprites/p1/Eve 45 Deg.png")
var eve_90_degrees = preload("res://assets/sprites/p1/Eve 90 Deg.png")
var eve_135_degrees = preload("res://assets/sprites/p1/Eve 135 Deg.png")
var eve_180_degrees = preload("res://assets/sprites/p1/Eve 180 Deg.png")
var eve_225_degrees = preload("res://assets/sprites/p1/Eve 225 Deg.png")
var eve_270_degrees = preload("res://assets/sprites/p1/Eve 270 Deg.png")
var eve_315_degrees = preload("res://assets/sprites/p1/Eve 315 Deg.png")

func _physics_process(delta):
	var direction = Input.get_vector("P1Left", "P1Right", "P1Up", "P1Down")
	velocity = direction * SPEED
	
	# INFO Have Eve's texture face the direction of the player movement 
	if Input.is_action_pressed("P1Left") and not (Input.is_action_pressed("P1Up") or Input.is_action_pressed("P1Down")):
		$Sprite2D.texture = eve_270_degrees
	elif Input.is_action_pressed("P1Right") and not (Input.is_action_pressed("P1Up") or Input.is_action_pressed("P1Down")):
		$Sprite2D.texture = eve_90_degrees
	elif Input.is_action_pressed("P1Up") and not (Input.is_action_pressed("P1Left") or Input.is_action_pressed("P1Right")):
		$Sprite2D.texture = eve_180_degrees
	elif Input.is_action_pressed("P1Down") and not (Input.is_action_pressed("P1Left") or Input.is_action_pressed("P1Right")):
		$Sprite2D.texture = eve_0_degrees
	elif Input.is_action_pressed("P1Left") and Input.is_action_pressed("P1Up"):
		$Sprite2D.texture = eve_225_degrees
	elif Input.is_action_pressed("P1Left") and Input.is_action_pressed("P1Down"):
		$Sprite2D.texture = eve_315_degrees
	elif Input.is_action_pressed("P1Right") and Input.is_action_pressed("P1Up"):
		$Sprite2D.texture = eve_135_degrees
	elif Input.is_action_pressed("P1Right") and Input.is_action_pressed("P1Down"):
		$Sprite2D.texture = eve_45_degrees
	
	move_and_slide()
