#@tool
extends CharacterBody2D

# following code from vision code 2d addon example scene

@export var visionRenderer: Polygon2D
@export var alertColor: Color

@export_group("Rotation")
@export var isRotating = false
@export var rotationSpeed = 0.1
@export var rotationAngle = 90

#@export_group("Movement")
#@export var moveOnPath: PathFollow2D
#@export var movementSpeed = 0.1
#@onready var pos_start = position.x

@onready var originalColor = visionRenderer.color if visionRenderer else Color.WHITE
@onready var rotStart = 180

# end of example scene code

@export var targets: Array[CharacterBody2D]
var playerChase = false
var player = null
signal sleeplessChildAttack

var returnToPath = false
var returnLocation: Vector2
@onready var navAgent: NavigationAgent2D = $NavigationAgent2D
@export var pathFollow: PathFollow2D

@onready var sleeplessChildSprite: Sprite2D = $EnemySprite
@onready var attackZone: Area2D = $AttackZone
@onready var visionCone = $VisionCone2D
var normalSpeed = 60
var secondarySpeed = 80
var damage = 0

@export var death_effect_scene: PackedScene = preload("res://scenes/death_effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
# calls movement behavior function
func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	sleepless_child_behavior(delta)
	var angle = pathFollow.rotation
	if abs(angle) > PI/2:
		sleeplessChildSprite.flip_h = false
		attackZone.scale.x = -1
	else:
		sleeplessChildSprite.flip_h = true
		attackZone.scale.x = 1
	
	if player and playerChase:
		var angleOffset = deg_to_rad(-90)
		var playerAngle = global_position.angle_to_point(player.global_position)
		visionCone.rotation = lerp_angle(visionCone.rotation, playerAngle + angleOffset, 5 * delta)
	else:
		rotating_vision_cone()
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
		
func sleepless_child_behavior(delta: float):
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

# from vision code 2d addon example scene
func rotating_vision_cone():
	var angleOffset = deg_to_rad(-90)
	var enemyDir = 0.0
	if pathFollow:
		enemyDir = pathFollow.rotation
	else:
		if sleeplessChildSprite.flip_h:
			enemyDir = PI 
		else:
			enemyDir = 0.0
	if isRotating:
		visionCone.rotation = angleOffset + enemyDir + sin(Time.get_ticks_msec()/1000. * rotationSpeed) * deg_to_rad(rotationAngle/2.)
	else:
		visionCone.rotation = angleOffset + enemyDir

func _on_attack_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player = area.get_parent()
		var playerName = player.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		sleeplessChildAttack.emit()


func _on_attack_zone_area_exited(area: Area2D) -> void:
	pass # Replace with function body.


func _on_vision_cone_area_area_entered(area: Area2D) -> void:
	visionRenderer.color = alertColor
	# check the object in the detection zone is a player
	if area.is_in_group("HurtBox"):
		# set player to the current player in the detection zone and begin chase
		player = area.get_parent()
		playerChase = true


func _on_vision_cone_area_area_exited(area: Area2D) -> void:
	visionRenderer.color = originalColor
	# check if the player exiting is the current player
	if area.get_parent() == player:
		# set player to null as there is no player in the zone
		player = null
		playerChase = false
		# check if path follow is toggled
		if pathFollow:
			# return to path 
			returnLocation = pathFollow.global_position
			returnToPath = true
