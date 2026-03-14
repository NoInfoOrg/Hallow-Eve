# INFO Source: https://www.youtube.com/watch?v=Ykz7W9BHzPg

extends CharacterBody2D

@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

# Can be set to whoever we want the enemy to chase later
# Could be changed to a vector to follow multiple targets?
@export var targets: Array[CharacterBody2D]
@export var optional_lurker = false

const SPEED = 50.0

# The distance for the blanket ghost to start being visible to the players
const VISIBLE_THRESHOLD = 750.0
#const VISIBLE_THRESHOLD = 200.0  # For testing

# The distance for the blanket ghost to start being fully visible to the players
const FULL_OPACITY_THRESHOLD = 150.0

# This will probably be changed to a cone-shaped vision in the future
const MAX_LINE_OF_SIGHT_DISTANCE = 800.0

# Attack cooldown
var timer = Timer.new()
var is_in_attack_cooldown = false
var ATTACK_COOLDOWN_TIME_SECONDS = 3.0  # 3 second cooldown?
signal blanket_ghost_attack

# Idle movement
var idle_action_timer = Timer.new()
var previous_idle_movement = "stop"
var previous_velocity = Vector2(0, 0)
const MAX_IDLE_SPEED_MULTIPLIER = 0.8
const IDLE_STOP_TIME_SECONDS = 3.0
const IDLE_MOVE_TIME_SECONDS = 3.0

func _ready() -> void:
	if optional_lurker:
		get_node("Sprite2D").self_modulate.a = 0
	
	# Set up the timer for the blanket ghost's attack cooldown
	add_child(timer)
	add_child(idle_action_timer)
	timer.timeout.connect(_on_timer_timeout)
	idle_action_timer.timeout.connect(_on_idle_action_timer_timeout)
	
	# Turn off physics processing
	set_physics_process(false)
	call_deferred("wait_for_physics")

func wait_for_physics():
	await get_tree().physics_frame
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	var target = get_closest_target()
	#print(get_diagonal_distance(target))
	
	# Only move the blanket ghost to a player if the players are in range
	if get_diagonal_distance(target) > MAX_LINE_OF_SIGHT_DISTANCE:
		#print("Blanket Ghost is not in range of any targets")
		
		# Potential idle movement
		move_idle()
		return
	
	# At this point, we assume that the blanket ghost will no longer be idle
	reset_idle_variables()
	
	# Check for collision with Eve or Willow
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.get("name") in ["Eve - P1", "Willow - P2"]:
			if not is_in_attack_cooldown:
				#print("Blanket Ghost attack on " + collider.get("name"))
				
				blanket_ghost_attack.emit()
				is_in_attack_cooldown = true
				
				timer.wait_time = ATTACK_COOLDOWN_TIME_SECONDS
				timer.start()
	
	# Fix the jittering when the blanket ghost stops at the player
	var at_target_position = target.global_position == navigation_agent.target_position
	if navigation_agent.is_navigation_finished() and at_target_position:
		return
	
	navigation_agent.target_position = target.global_position
	
	# direction_to() gives a normalized vector?
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * SPEED
	
	move_and_slide()
	
	# Change the blanket ghost's opacity if we optionally want it to be a lurker
	if optional_lurker:
		set_transparency(target)

func _on_timer_timeout():
	timer.stop()
	is_in_attack_cooldown = false

func get_closest_target():
	var current_lowest_distance = 0
	var closest_target
	var is_first_target = true
	
	for target in targets:
		var diagonal_distance = get_diagonal_distance(target)
		
		if is_first_target:
			current_lowest_distance = diagonal_distance
			closest_target = target
			
			is_first_target = false
			continue
		
		if diagonal_distance < current_lowest_distance:
			current_lowest_distance = diagonal_distance
			closest_target = target
	
	return closest_target

func get_diagonal_distance(target):
		var distance_vector = target.global_position - global_position
	
		# Calculating the hypothenuse with the Pythagorean Theorem
		var diagonal_distance = sqrt(pow(distance_vector[0], 2) + pow(distance_vector[1], 2))
		
		return diagonal_distance

func set_transparency(target):
	var diagonal_distance = get_diagonal_distance(target)
	#print(diagonal_distance)
	
	# distance <= 100 = opacity = 1
	if diagonal_distance <= FULL_OPACITY_THRESHOLD:
		get_node("Sprite2D").self_modulate.a = 1
		return
	
	# distance >= 600 = opacity = 0
	if diagonal_distance >= VISIBLE_THRESHOLD:
		get_node("Sprite2D").self_modulate.a = 0
		return
	
	# Otherwise, set the opacity based on the following:
	# Opacity = 1 - ((distance - FULL_OPACITY_THRESHOLD) / (VISIBLE_THRESHOLD - FULL_OPACITY_THRESHOLD))
	var offsetted_distance = diagonal_distance - FULL_OPACITY_THRESHOLD
	var threshold_difference = VISIBLE_THRESHOLD - FULL_OPACITY_THRESHOLD
	get_node("Sprite2D").self_modulate.a = 1 - (offsetted_distance / threshold_difference)

func move_idle():
	if idle_action_timer.get_time_left() != 0:
		# Keep moving if the ghost is still moving in idle animation
		if previous_idle_movement == "move":
			#print("still moving")
			velocity = previous_velocity
			move_and_slide()
			
		return
	
	var rng = RandomNumberGenerator.new()
	
	var idle_options = ["stop", "move"]
	previous_idle_movement = idle_options[randi_range(0, idle_options.size() - 1)]
	#print(previous_idle_movement)
	
	if previous_idle_movement == "stop":
		# Start a timer to stop for
		idle_action_timer.wait_time = IDLE_STOP_TIME_SECONDS
		idle_action_timer.start()
		
	elif previous_idle_movement == "move":
		# Move in a random direction
		var random_x = rng.randf_range(-MAX_IDLE_SPEED_MULTIPLIER, MAX_IDLE_SPEED_MULTIPLIER)
		var random_y = rng.randf_range(-MAX_IDLE_SPEED_MULTIPLIER, MAX_IDLE_SPEED_MULTIPLIER)
		
		velocity = Vector2(random_x, random_y) * SPEED
		previous_velocity = velocity
		move_and_slide()
		
		# Start a timer to continue moving in that direction for
		idle_action_timer.wait_time = IDLE_MOVE_TIME_SECONDS
		idle_action_timer.start()

func _on_idle_action_timer_timeout():
	idle_action_timer.stop()
	reset_idle_variables()

func reset_idle_variables():
	previous_idle_movement = "stop"
	previous_velocity = Vector2(0, 0)
