@tool
extends CharacterBody2D

@export var plushieSprite: Texture2D:
	set(image):
		plushieSprite = image
		if $EnemySprite != null:
			$EnemySprite.texture = image 

@export var speed = 25
@export var targets: Array[CharacterBody2D]
var playerChase = false
var player = null

func _physics_process(delta: float) -> void:
	if playerChase:
		#var playerDirection = (player.position - position).normalized()
		#position += playerDirection * speed * delta
		position += (player.position - position) / speed	
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
	


func _on_detection_zone_body_entered(playerBody: Node2D) -> void:
	if playerBody.is_in_group("Players"):
		player = playerBody
		playerChase = true


func _on_detection_zone_body_exited(playerBody: Node2D) -> void:
	if playerBody == player:
		player = null
		playerChase = false
