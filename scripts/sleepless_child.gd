#@tool
extends CharacterBody2D

@export var targets: Array[CharacterBody2D]
var player = null
signal sleeplessChildAttack

var returnToPath = false
var returnLocation: Vector2
@onready var navAgent: NavigationAgent2D = $NavigationAgent2D
@export var pathFollow: PathFollow2D

enum SleeplessChildStates {Idle, Chase, Calm, Dash}
var currentState = SleeplessChildStates.Idle
var dashTime = 0.3
var dashCooldownTimer = 0.0

@onready var sleeplessChildSprite: Sprite2D = $EnemySprite
@onready var attackZone: Area2D = $AttackZone
@onready var detectZone: Area2D = $DetectionZone
@onready var enemyCollider: CollisionShape2D = $EnemyCollider
var normalSpeed = 60
var secondarySpeed = 80
var damage = 1
var attackCooldown = Timer
var cooldownTime = 0.5
var musicBoxPlays = 0

@export var death_effect_scene: PackedScene = preload("res://scenes/death_effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackCooldown = Timer.new()
	attackCooldown.wait_time = cooldownTime
	attackCooldown.one_shot = false
	add_child(attackCooldown)
	attackCooldown.timeout.connect(on_attack_cooldown)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# calls movement behavior function
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	update_sleepless_child_state(delta)
	if velocity.x > 0:
		sleeplessChildSprite.flip_h = false
		attackZone.scale.x = 1
		detectZone.scale.x = 1
		enemyCollider.scale.x = 1
	elif velocity.x < 0:
		sleeplessChildSprite.flip_h = true
		attackZone.scale.x = -1
		detectZone.scale.x = -1
		enemyCollider.scale.x = -1
	move_and_slide()

func sleepless_child_attack():
	pass

# nick's func to get closest target
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

# also nick's func to get diagonal distance
func get_diagonal_distance(target):
		var distance_vector = target.global_position - global_position
	
		# Calculating the hypothenuse with the Pythagorean Theorem
		var diagonal_distance = sqrt(pow(distance_vector[0], 2) + pow(distance_vector[1], 2))
		
		return diagonal_distance
		
		
func update_sleepless_child_state(delta):
	match currentState:
		SleeplessChildStates.Idle:
			sleepless_child_idle_behavior(delta)
		SleeplessChildStates.Chase:
			sleepless_child_chase_behavior(delta)
		SleeplessChildStates.Dash:
			sleepless_child_dash_behavior(delta)
		SleeplessChildStates.Calm:
			sleepless_child_calm_behavior(delta)
			
			
func sleepless_child_idle_behavior(delta):
	if returnToPath:
		move_to_path(normalSpeed, delta)
	elif pathFollow:
		move_on_path(normalSpeed, delta)

func sleepless_child_chase_behavior(delta):
	player = get_closest_target()
	if player:
		move_toward_target(player.global_position, secondarySpeed)
		dashCooldownTimer -= delta
		if dashCooldownTimer <= 0:
			dashCooldownTimer = randf_range(1.0, 2.0)
			if randf() < 0.35:
				print("DASH")
				sleepless_child_dash_start()
	else:
		currentState = SleeplessChildStates.Idle
		
func sleepless_child_dash_start():
	currentState = SleeplessChildStates.Dash
	get_tree().create_timer(dashTime).timeout.connect(sleepless_child_dash_end)
	
func sleepless_child_dash_end():
	if currentState == SleeplessChildStates.Dash:
		currentState = SleeplessChildStates.Chase

func sleepless_child_dash_behavior(delta):
	player = get_closest_target()
	if player:
		move_toward_target(player.global_position, secondarySpeed * 5)

func sleepless_child_calm_behavior(delta):
	if musicBoxPlays == 1:
		move_on_path(40, delta)
	elif musicBoxPlays == 2:
		move_on_path(25, delta)
	elif musicBoxPlays == 3:
		move_on_path(10, delta)
		attackZone.set_deferred("monitoring", false)

func play_music_box():
	musicBoxPlays += 1
	if musicBoxPlays == 1:
		damage = 1
		currentState = SleeplessChildStates.Calm
	elif musicBoxPlays == 2:
		damage = 0.5
	elif musicBoxPlays >= 3:
		damage = 0
		currentState = SleeplessChildStates.Calm


#func sleepless_child_behavior(delta: float):
	## check if the player is being chased
	#if playerChase:
		## if so then get the closest target and set that to player
		#player = get_closest_target()
		## check if player is not null
		#if player:
			## toggle return to path as the rat is chasing and move toward the player
			#returnToPath = false
			#move_toward_target(player.global_position, secondarySpeed)
	## otherwise player is not being chased
	#else:
		## check if the rat should return to the path
		#if returnToPath:
			## return to the path
			#move_to_path(delta)
		## also check if path follow
		#elif pathFollow:
			## move the rat along the path
			#move_on_path(normalSpeed, delta)

func on_attack_cooldown():
	if player:
		var playerName = player.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		sleeplessChildAttack.emit()

# moves the plushie along a path
func move_on_path(speed: float, delta: float) -> void:
	# get the path length
	var pathLength = pathFollow.get_parent().curve.get_baked_length()
	# check if the length is greater than 0
	if pathLength > 0:
		# update the progress on the path
		pathFollow.progress_ratio += (normalSpeed * delta) / pathLength
		var direction = pathFollow.global_position - global_position
		velocity = direction.normalized() * speed

# moves the plushie toward the path if it is no longer chasing
func move_to_path(speed: float, delta: float) -> void:
	# gets the direction to the path
	var direction = returnLocation - global_position
	# check if the length of the direction is less than 5 (made it to the path)
	if direction.length() < 5:
		# toggle return to path since it has made it to the path and return
		returnToPath = false
		velocity = Vector2.ZERO
		return
	# otherwise the plushie still needs to move toward the path
	else:
		velocity = direction.normalized() * speed

# moves the plushie toward a target player
func move_toward_target(playerLocation: Vector2, speed: float):
	navAgent.target_position = playerLocation
	var nextLocation = navAgent.get_next_path_position()
	var direction = nextLocation - global_position
	if direction.length() > 0.1:
		velocity = direction.normalized() * speed
	else:
		direction = player.global_position - global_position
		if direction.length() > 0.1:
			velocity = direction.normalized() * speed
		else:
			velocity = Vector2.ZERO

func _on_attack_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player = area.get_parent()
		var playerName = player.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		sleeplessChildAttack.emit()
		attackCooldown.start()

func _on_attack_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		attackCooldown.stop()

func _on_detection_zone_area_entered(area: Area2D) -> void:
	# check the object in the detection zone is a player
	if area.is_in_group("HurtBox"):
		# set player to the current player in the detection zone and begin chase
		player = area.get_parent()
		if currentState != SleeplessChildStates.Calm:
			currentState = SleeplessChildStates.Chase

func _on_detection_zone_area_exited(area: Area2D) -> void:
	# check if the player exiting is the current player
	if area.get_parent() == player:
		# set player to null as there is no player in the zone
		player = null
		if currentState != SleeplessChildStates.Calm:
			currentState = SleeplessChildStates.Idle
		# check if path follow is toggled
		if pathFollow:
			# return to path 
			returnLocation = pathFollow.global_position
			returnToPath = true
