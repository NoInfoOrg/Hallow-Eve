extends CharacterBody2D

var can_move = true

const MAX_PUSH_SPEED = 150.0

func _physics_process(delta: float) -> void:
	if (velocity[0] > MAX_PUSH_SPEED):
		velocity = Vector2(MAX_PUSH_SPEED, velocity[1])
	elif (velocity[0] < -MAX_PUSH_SPEED):
		velocity = Vector2(-MAX_PUSH_SPEED, velocity[1])
	elif (velocity[1] > MAX_PUSH_SPEED):
		velocity = Vector2(velocity[0], MAX_PUSH_SPEED)
	elif (velocity[1] < -MAX_PUSH_SPEED):
		velocity = Vector2(velocity[0], -MAX_PUSH_SPEED)
	
	# move_and_slide() caused issues with boxes moving with Eve even when Eve is not pushing the boxes 
	move_and_collide(velocity * delta)
	
	if get_slide_collision_count() == 0:
		velocity = Vector2(0, 0)
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		var normal = collision.get_normal()
		# print(normal)
		
		const LEFT_DIRECTION = Vector2(-1.0, 0.0)
		const RIGHT_DIRECTION = Vector2(1.0, 0.0)
		const UP_DIRECTION = Vector2(0.0, -1.0)
		const DOWN_DIRECTION = Vector2(0.0, 1.0)
		
		if collision_box.is_in_group("Spirit Boxes"):
			velocity = Vector2(0, 0)
		else:  # Should probably be changed to only players later
			if velocity[0] != 0 and (normal == UP_DIRECTION or normal == DOWN_DIRECTION):
				velocity = Vector2(0, 0)
			elif velocity[1] != 0 and (normal == LEFT_DIRECTION or normal == RIGHT_DIRECTION):
				velocity = Vector2(0, 0)

func push_by_player(direction, push_force):
	velocity = direction * push_force
