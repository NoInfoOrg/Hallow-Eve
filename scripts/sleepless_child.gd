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
@onready var lineOfSightRay: RayCast2D = RayCast2D.new()
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
	
	add_child(lineOfSightRay)
	lineOfSightRay.enabled = false
	var layersToCollide = [2, 4, 5, 8, 9, 10]
	for layer in layersToCollide:
		lineOfSightRay.set_collision_mask_value(layer, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# calls movement behavior function
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	update_sleepless_child_state(delta)
	if velocity.x > 0.5:
		sleeplessChildSprite.flip_h = false
		attackZone.scale.x = 1
		detectZone.scale.x = 1
		enemyCollider.scale.x = 1
	elif velocity.x < -0.5:
		sleeplessChildSprite.flip_h = true
		attackZone.scale.x = -1
		detectZone.scale.x = -1
		enemyCollider.scale.x = -1
	move_and_slide()


func sleepless_child_attack():
	pass

# checks to make sure there is nothing between enemy and player before doing damage 
func check_line_of_sight() -> bool:
	if not player:
		return false
	lineOfSightRay.target_position = to_local(player.global_position)
	lineOfSightRay.force_raycast_update()
	if lineOfSightRay.is_colliding():
		var collider = lineOfSightRay.get_collider()
		if collider != player and not collider.is_in_group("HurtBox"):
			return false
	return true

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
		
# changes between sleepless child states
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
			
# defines sleepless child idle behavior
func sleepless_child_idle_behavior(delta):
	if returnToPath:
		move_to_path(normalSpeed, delta)
	elif pathFollow:
		move_on_path(normalSpeed, delta)

# defines sleepless child chase behavior
func sleepless_child_chase_behavior(delta):
	player = get_closest_target()
	if player:
		move_toward_target(player.global_position, secondarySpeed)
		dashCooldownTimer -= delta
		if dashCooldownTimer <= 0:
			dashCooldownTimer = randf_range(1.0, 2.0)
			if randf() < 0.35:
				sleepless_child_dash_start()
	else:
		currentState = SleeplessChildStates.Idle

# begins the sleepless child dash 
func sleepless_child_dash_start():
	currentState = SleeplessChildStates.Dash
	get_tree().create_timer(dashTime).timeout.connect(sleepless_child_dash_end)

# ends sleepless child dash
func sleepless_child_dash_end():
	if currentState == SleeplessChildStates.Dash:
		currentState = SleeplessChildStates.Chase

# defines sleepless child dash behavior
func sleepless_child_dash_behavior(delta):
	player = get_closest_target()
	if player:
		move_toward_target(player.global_position, secondarySpeed * 5)

# defines sleepless child calm behavior
func sleepless_child_calm_behavior(delta):
	if musicBoxPlays == 1:
		move_on_path(40, delta)
	elif musicBoxPlays == 2:
		move_on_path(25, delta)
	elif musicBoxPlays == 3:
		move_on_path(10, delta)
		attackZone.set_deferred("monitoring", false)

# updates music box plays to update calm state
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

# checks if attack is on cooldown
func on_attack_cooldown():
	if player:
		var playerName = player.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		sleeplessChildAttack.emit()

# moves the sleepless child along a path
func move_on_path(speed: float, delta: float) -> void:
	var pathLength = pathFollow.get_parent().curve.get_baked_length()
	if pathLength > 0:
		pathFollow.progress_ratio += (speed * delta) / pathLength
		var targetPos = pathFollow.global_position
		var movementToPath = targetPos - global_position
		velocity = movementToPath / delta

# moves the sleepless child toward the path if it is no longer chasing
func move_to_path(speed: float, delta: float) -> void:
	var direction = returnLocation - global_position
	if direction.length() < 5:
		returnToPath = false
		global_position = returnLocation
		velocity = Vector2.ZERO
		return
	else:
		if direction.length() < speed * delta:
			velocity = direction / delta
		else:
			velocity = direction.normalized() * speed

# moves the sleepless child toward a target player
func move_toward_target(playerLocation: Vector2, speed: float):
	navAgent.target_position = playerLocation
	var nextLocation = navAgent.get_next_path_position()
	var direction = nextLocation - global_position
	if direction.length() > 2.0:
		velocity = direction.normalized() * speed
	else:
		direction = player.global_position - global_position
		if direction.length() > 2.0:
			velocity = direction.normalized() * speed
		else:
			velocity = Vector2.ZERO

# detects if player is in attack range
func _on_attack_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player = area.get_parent()
		var playerName = player.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		sleeplessChildAttack.emit()
		attackCooldown.start()

# detects if player leaves attack range
func _on_attack_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		attackCooldown.stop()

# detects if player is in the detection range
func _on_detection_zone_area_entered(area: Area2D) -> void:
	# check the object in the detection zone is a player
	if area.is_in_group("HurtBox"):
		# set player to the current player in the detection zone and begin chase
		player = area.get_parent()
		if currentState != SleeplessChildStates.Calm:
			currentState = SleeplessChildStates.Chase

# detects if player exits the detection range
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
