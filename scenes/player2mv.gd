extends CharacterBody2D

@export var inv: Inv # shared inventory for Willow and Eve (I hope this works)
const SPEED = 300.0



func _physics_process(delta):
	var direction = Input.get_vector("P2Left", "P2Right", "P2Up", "P2Down")
	velocity = direction * SPEED
	
	move_and_slide()
