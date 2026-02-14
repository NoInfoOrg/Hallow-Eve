extends CharacterBody2D


const SPEED = 300.0



func _physics_process(delta):
	var direction = Input.get_vector("P2Left", "P2Right", "P2Up", "P2Down")
	velocity = direction * SPEED
	
	move_and_slide()
