@tool 
extends CharacterBody2D

@export var slimeSprite: Texture2D:
	set(image):
		slimeSprite = image 
		if $SlimeSprite2D != null: #If a slime sprite exists 
			$SlimeSprite2D.texture = image 

var speed = 80
var player_chase = false
var player = null 

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position)/speed # Move towards the player 
		
		# $AnimatedSprite2D.play("walk") -- For animation 
		
		#if(player.position.x - position.x) < 0:
			#$AnimatedSprite2D.flip_h = true
		#else:
			#AnimatedSprite2D.flip_h = false
	#else:
		# $AnimatedSprite@D.play("idle") -- For idle
	
func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body  # Whatever enters the zone, it is in the body
	player_chase = true # Chase the player 


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false # Player is out of the zone, do not chase 
	
