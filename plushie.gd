#@tool
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

enum PlushieType {Rocco, Cat, Choco, Freddy, MinionRat}

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
	},
	PlushieType.MinionRat: {
		"sprite": preload("res://assets/sprites/enemy/Plushies_Rocco.png"),
		"normalSpeed": 140,
		"secondarySpeed": 160,
		"damage": 0.1
	}
}

# death scene for plushies
@export var death_effect_scene: PackedScene = preload("res://scenes/death_effect.tscn")

# rocco specific variables
var returnToPath = false
var returnLocation: Vector2
var initialSqueak = false
@export var leaderRat: bool = true
@onready var navAgent: NavigationAgent2D = $NavigationAgent2D
@export var pathFollow: PathFollow2D
@onready var detectionSound: AudioStreamPlayer2D = $DetectionSound

# all plushie variables
var normalSpeed = 0
var secondarySpeed = 0
var damage = 0

# begins the plushie madness
func _ready():
	# setup enemy
	setup_enemy()
	# start self destruct timer if minion rat
	if plushieType == PlushieType.MinionRat:
		self_destruct_timer(10.0)

# sets up the plushie
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
	# depending on plushie type choose the correct behavior
	match plushieType:
		PlushieType.Rocco:
			rocco_behavior(delta)
		PlushieType.Cat:
			cat_behavior(delta)
		PlushieType.Choco:
			choco_behavior(delta)
		PlushieType.Freddy:
			freddy_behavior(delta)
		PlushieType.MinionRat:
			minion_rat_behavior(delta)
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
	# check the object in the detection zone is a player
	if playerBody.is_in_group("Players"):
		# set player to the current player in the detection zone and begin chase
		player = playerBody
		playerChase = true
		# check if the first time something has been detected and the rat is the leader
		if !initialSqueak and leaderRat:
			# gen a random number of rats
			var rng = RandomNumberGenerator.new()
			var randomNum = rng.randi_range(1, 4)
			for i in randomNum:
				# spawn minion rat
				call_deferred("rat_swarm_attack")
			# check for sound and not currently playing
			if detectionSound and not detectionSound.playing:
				# play the sound !
				detectionSound.play()
				initialSqueak = !initialSqueak

# checks if the player has left the detection zone
func _on_detection_zone_body_exited(playerBody: Node2D) -> void:
	# check if the player exiting is the current player
	if playerBody == player:
		# set player to null as there is no player in the zone
		player = null
		# check if rat is the leader
		if leaderRat:
			# if it is then toggle the chase
			playerChase = false
		# check if path follow is toggled
		if pathFollow:
			# return to path 
			returnLocation = pathFollow.global_position
			returnToPath = true

# defines rocco movement behavior (patrolling unless detecting a player)
func rocco_behavior(delta: float) -> void:
	# check if the player is being chased
	if playerChase:
		# if so then get the closest target and set that to player
		player = get_closest_target()
		# check if player is not null
		if player:
			# toggle return to path as the rat is chasing and move toward the player
			returnToPath = false
			move_toward_target(player.global_position, secondarySpeed)
	# otherwise player is not being chased
	else:
		# check if the rat should return to the path
		if returnToPath:
			# return to the path
			move_to_path(delta)
		# also check if path follow
		elif pathFollow:
			# move the rat along the path
			move_on_path(normalSpeed, delta)

# defines minion rat behavior
func minion_rat_behavior(delta: float) -> void:
	# check if the player should be chased
	if playerChase:
		# get the closest player
		player = get_closest_target()
		# check that player is not null
		if player:
			# move minion rat toward the player
			move_toward_target(player.global_position, secondarySpeed)

# summons a minion rat to attack alongside leader rat
func rat_swarm_attack() -> void:
	# check if the rat trying to summon is the leader
	if leaderRat:
		# load another plushie to instantiate a minion rat for the swarm attack
		var scenePath = self.scene_file_path
		var minionRat = load(scenePath).instantiate()
		# set minion rat attributes
		minionRat.plushieType = PlushieType.MinionRat
		minionRat.leaderRat = false
		minionRat.scale = Vector2(0.5, 0.5)
		minionRat.playerChase = true
		minionRat.death_effect_scene = death_effect_scene
		# set the naviations targets
		minionRat.targets = targets
		# add rat to the level tree and place rat in random pos
		get_tree().current_scene.add_child(minionRat)
		minionRat.global_position = get_random_minion_rat_position()
	# if not then it cannot summon
	else:
		return

func get_random_minion_rat_position() -> Vector2:
	# setup variables for cam
	var screenRect = get_viewport_rect()
	var screenSize = screenRect.size
	var camera = get_viewport().get_camera_2d()
	var cameraPos = Vector2.ZERO
	var spawnPos = Vector2.ZERO
	# check tha camera isnt null
	if camera:
		# get the cams pos
		cameraPos = camera.get_screen_center_position()
	# otherwise global pos
	else:
		cameraPos = global_position
	# setup margin and zoom variables (phantom cam zooms)
	var margin = 250.0
	var zoom = 1.0
	# check if cam 
	if camera:
		# get the zoom for the camera
		zoom = 1.0 / camera.zoom.x
	# pick a random side for the minion rat the spawn
	var spawnSide = randi() % 4
	match spawnSide:
		0:
			spawnPos.x = randf_range(cameraPos.x - (screenSize.x * zoom)/2, cameraPos.x + (screenSize.x * zoom)/2)
			spawnPos.y = cameraPos.y - ((screenSize.y * zoom)/2) - margin
		1:
			spawnPos.x = randf_range(cameraPos.x - (screenSize.x * zoom)/2, cameraPos.x + (screenSize.x * zoom)/2)
			spawnPos.y = cameraPos.y + ((screenSize.y * zoom)/2) + margin
		2:
			spawnPos.x = cameraPos.x - ((screenSize.x * zoom)/2) - margin
			spawnPos.y = randf_range(cameraPos.y - (screenSize.y * zoom)/2, cameraPos.y + (screenSize.y * zoom)/2)
		3:
			spawnPos.x = cameraPos.x + ((screenSize.x * zoom)/2) + margin
			spawnPos.y = randf_range(cameraPos.y - (screenSize.y * zoom)/2, cameraPos.y + (screenSize.y * zoom)/2)
	# return the random spawn pos
	return spawnPos

# sets a self destruct timer for the minion rat
func self_destruct_timer(seconds: float) -> void:
	var minionTimer = get_tree().create_timer(seconds)
	minionTimer.timeout.connect(plushie_death)
	
func cat_behavior(delta: float) -> void:
	pass
	
func choco_behavior(delta: float) -> void:
	pass
	
func freddy_behavior(delta: float) -> void:
	pass

# moves the plushie along a path
func move_on_path(speed: float, delta: float) -> void:
	# get the path length
	var pathLength = pathFollow.get_parent().curve.get_baked_length()
	# check if the length is greater than 0
	if pathLength > 0:
		# update the progress on the path
		pathFollow.progress_ratio += (normalSpeed * delta) / pathLength
		var direction = pathFollow.global_position - global_position
		velocity = direction.normalized() * normalSpeed

# moves the plushie toward the path if it is no longer chasing
func move_to_path(delta: float) -> void:
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
		player = playerBody
		var playerName = playerBody.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		plushieAttack.emit()
		plushie_death()


func _on_attack_zone_body_exited(playerBody: Node2D) -> void:
	if playerBody == player:
		player = null
