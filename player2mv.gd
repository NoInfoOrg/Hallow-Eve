extends CharacterBody2D

@export var player_id = 2
const SPEED = 300.0



func _physics_process(delta):
	var direction = get_direction()
	velocity = direction * SPEED
	
	move_and_slide()
func get_direction():
	match player_id:
		1: return Input.get_vector("P1Left", "P1Right", "P1Up", "P1Down")
		2: return Input.get_vector("P2Left", "P2Right", "P2Up", "P2Down")
		_: return Vector2.ZERO
