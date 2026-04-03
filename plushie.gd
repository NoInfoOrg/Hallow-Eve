@tool
extends CharacterBody2D

### variable info for players ###

@export var targets: Array[CharacterBody2D]
var playerChase = false
var player = null
signal plushieAttack

### variable info for plushies ###

# displays plushie visual change in editor and sets up attributes
@export var plushieType: PlushieType:
	set(value):
		plushieType = value
		setup_enemy()

enum PlushieType {Rocco, Cat, Choco, Freddy}

# plushie pre-defined attributes (see Enemy AI google doc)
var plushieAttributes = {
	PlushieType.Rocco: {
		"sprite": preload("res://assets/sprites/enemy/Plushies_Rocco.png"),
		"normalSpeed": 100,
		"secondarySpeed": 125,
		"damage": 0.25
	},
	PlushieType.Cat: {
		"sprite": preload("res://assets/sprites/enemy/Plushies_Cat.png"),
		"normalSpeed": 50,
		"secondarySpeed": 150,
		"damage": 0.25
	},
	PlushieType.Choco: {
		"sprite": preload("res://assets/sprites/enemy/Plushies_Choco.png"),
		"normalSpeed": 150,
		"secondarySpeed": 150,
		"damage": 0.25
	},
	PlushieType.Freddy: {
		"sprite": preload("res://assets/sprites/enemy/Plushies_Freddy.png"),
		"normalSpeed": 75,
		"secondarySpeed": 150,
		"damage": 0.25
	}
}

# death scene for plushies
@export var death_effect_scene: PackedScene = preload("res://scenes/death_effect.tscn")

# rocco specific variables
var returnToPath = false
var returnLocation: Vector2
var initialSqueak = false
@onready var navAgent: NavigationAgent2D = $NavigationAgent2D
@export var pathFollow: PathFollow2D
@onready var detectionSound: AudioStreamPlayer2D = $DetectionSound

# all plushie variables
var normalSpeed = 0
var secondarySpeed = 0
var damage = 0


func _ready():
	setup_enemy()
			
func setup_enemy():
	if $EnemySprite != null:
		var plushieAttribute = plushieAttributes.get(plushieType)
		if plushieAttribute != null:
			$EnemySprite.texture = plushieAttribute["sprite"]
			normalSpeed = plushieAttribute["normalSpeed"]
			secondarySpeed = plushieAttribute["secondarySpeed"]
			damage = plushieAttribute["damage"]
	else:
		return

# calls movement behavior function depending on which plushie is selected
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	match plushieType:
		PlushieType.Rocco:
			rocco_behavior(delta)
		PlushieType.Cat:
			cat_behavior(delta)
		PlushieType.Choco:
			choco_behavior(delta)
		PlushieType.Freddy:
			freddy_behavior(delta)
	move_and_slide()

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

# checks if detection zone is entered by player
func _on_detection_zone_body_entered(playerBody: Node2D) -> void:
	if playerBody.is_in_group("Players"):
		player = playerBody
		playerChase = true
		if !initialSqueak:
			if detectionSound and not detectionSound.playing:
				detectionSound.play()
				initialSqueak = !initialSqueak

# checks if the player has left the detection zone
func _on_detection_zone_body_exited(playerBody: Node2D) -> void:
	if playerBody == player:
		player = null
		playerChase = false
		if pathFollow:
			returnLocation = pathFollow.global_position
			returnToPath = true

# defines rocco movement behavior (patrolling unless detecting a player)
func rocco_behavior(delta: float) -> void:
	if playerChase:
		player = get_closest_target()
		if player:
			returnToPath = false
			move_toward_target(player.global_position, secondarySpeed)
			
	else:
		if returnToPath:
			move_to_path(delta)
		elif pathFollow:
			move_on_path(normalSpeed, delta)
	
func cat_behavior(delta: float) -> void:
	pass
	
func choco_behavior(delta: float) -> void:
	pass
	
func freddy_behavior(delta: float) -> void:
	pass
	
func move_on_path(speed: float, delta: float) -> void:
	var pathLength = pathFollow.get_parent().curve.get_baked_length()
	if pathLength > 0:
		pathFollow.progress_ratio += (normalSpeed * delta) / pathLength
		var direction = pathFollow.global_position - global_position
		velocity = direction.normalized() * normalSpeed
		
func move_to_path(delta: float) -> void:
	var direction = returnLocation - global_position
	if direction.length() < 5:
		returnToPath = false
		velocity = Vector2.ZERO
		return
	velocity = direction.normalized() * normalSpeed
		
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
			
func plushie_death():
	var deathEffect = death_effect_scene.instantiate()
	deathEffect.global_position = global_position
	get_tree().current_scene.add_child(deathEffect)
	deathEffect.emitting = true
	queue_free()

func _on_attack_zone_body_entered(playerBody: Node2D) -> void:
	if playerBody.is_in_group("Players"):
		var playerName = playerBody.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		plushieAttack.emit()
		plushie_death()
