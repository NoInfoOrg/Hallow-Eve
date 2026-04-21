extends CharacterBody2D

@export var speed = 100.0
@export var wander_radius = 200.0
@export var detect_radius = 400.0

var target_position: Vector2
var player_to_chase: CharacterBody2D = null
enum State {Wander, Chase}
var current_state = State.Wander
@export var damage = 1.0

func _ready():
	wander_target()


func _physics_process(delta: float) -> void:
	match current_state:
		State.Wander:
			wander_behavior(delta)
		State.Chase:
			chase_behavior(delta)
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	elif velocity.x < 0:
		$Sprite2D.flip_h = true
		
	if velocity.length() > 0:
		if $AnimationPlayer.current_animation != "FlyBook_Fly":
			$AnimationPlayer.play("FlyBook_Fly")
	else:
		$AnimationPlayer.stop()
	
func wander_target():
	var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * wander_radius
	target_position = global_position + random_offset
	
func wander_behavior(delta):
	var direction = global_position.direction_to(target_position)
	velocity = direction * (speed * 0.5)
	if global_position.distance_to(target_position) < 10:
		wander_target()
	move_and_slide()
	
func chase_behavior(delta):
	if is_instance_valid(player_to_chase):
		var direction = global_position.direction_to(player_to_chase.global_position)
		velocity = direction * speed
		
		# Optional: Stop chasing if player gets too far
		if global_position.distance_to(player_to_chase.global_position) > detect_radius * 1.5:
			player_to_chase = null
			current_state = State.Wander
	else:
		current_state = State.Wander
		
	move_and_slide()


func _on_detection_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		var player = area.get_parent()
		player_to_chase = player
		current_state = State.Chase


func _on_detection_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player_to_chase = null
		current_state = State.Wander


func _on_attack_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		var player = area.get_parent()
		if player:
			var playerName = player.name
			GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)


func _on_attack_zone_area_exited(area: Area2D) -> void:
	pass # Replace with function body.
