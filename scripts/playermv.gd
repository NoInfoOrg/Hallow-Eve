extends CharacterBody2D


const SPEED = 300.0



func _physics_process(delta):
	var direction = Input.get_vector("P1Left", "P1Right", "P1Up", "P1Down")
	velocity = direction * SPEED
	
	move_and_slide()
