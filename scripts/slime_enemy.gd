@tool 
extends CharacterBody2D

@export var slimeSprite: Texture2D:
	set(image):
		slimeSprite = image 
		if $SlimeSprite2D != null: #If a slime sprite exists 
			$SlimeSprite2D.texture = image 

enum EnemyStates {
	Idle,
	Wander,
	Chase
}
var current_state = EnemyStates.Idle
var enemy_state_timer: Timer

var speed = 80
var damage = 0.25
var cooldown_time = 0.5
var player_chase = false
var player = null 
var attack_cooldown = null
var slime_bounce_tween: Tween
var wander_direction: Vector2 = Vector2.ZERO
var wander_speed: float = 40


signal slimeAttack
@onready var warning_particles: CPUParticles2D = $WarningParticles


@export var slimeType: SlimeType:
	set(value):
		slimeType = value
		setup_slime()

enum SlimeType {Gumpy, Squid, Fish}
		
var SlimeSprites = {
	SlimeType.Gumpy: {
		"sprite": preload("res://assets/sprites/enemy/Slimes_Gumpy.png")
	},
	SlimeType.Squid: {
		"sprite": preload("res://assets/sprites/enemy/Slimes_Squid.png")
	},
	SlimeType.Fish: {
		"sprite": preload("res://assets/sprites/enemy/Slimes_Fish.png")
	}
}

func setup_slime():
	if $SlimeSprite2D != null:
		var slime = SlimeSprites.get(slimeType)
		if slime != null:
			$SlimeSprite2D.texture = slime["sprite"]
	else:
		return

func _ready():
	warning_color(Color.GREEN)
	attack_cooldown = Timer.new()
	attack_cooldown.wait_time = cooldown_time
	attack_cooldown.one_shot = false
	add_child(attack_cooldown)
	attack_cooldown.timeout.connect(on_attack_cooldown)
	
	enemy_state_timer = Timer.new()
	enemy_state_timer.wait_time = 2.0
	enemy_state_timer.one_shot = false
	enemy_state_timer.autostart = true
	add_child(enemy_state_timer)
	enemy_state_timer.timeout.connect(enemy_state_timer_timeout)

func _physics_process(delta: float) -> void:
	match current_state:
		EnemyStates.Idle:
			velocity = Vector2.ZERO
		EnemyStates.Wander:
			velocity = wander_direction * wander_speed
		EnemyStates.Chase:
			if player:
				var direction = (player.position - position).normalized()
				velocity = direction * speed
	move_and_slide()
	if velocity.length() > 5:
		var bounce_height = abs(sin(Time.get_ticks_msec() * 0.01)) * 10.0
		$SlimeSprite2D.position.y = -bounce_height
		start_slime_bounce()
	else:
		stop_slime_bounce()

func _process(delta):
	if player:
		var distance_to_player = position.distance_to(player.position)
		if distance_to_player < 100:
			warning_color(Color.RED)
			warning_particles.speed_scale = 2
		elif distance_to_player < 200:
			warning_color(Color.YELLOW)
			warning_particles.speed_scale = 1.2
		else:
			warning_color(Color.GREEN)
			warning_particles.speed_scale = 0.6

func on_attack_cooldown():
	if player:
		var playerName = player.name
		GlobalInformation.deal_strike_damage_to_player(self, playerName, damage)
		slimeAttack.emit()

func warning_color(color: Color):
	warning_particles.modulate = color

func slime_behavior():
	pass
	

func enemy_state_timer_timeout():
	if current_state == EnemyStates.Chase:
		return
	var random_state = randi() % 2
	if random_state == 0:
		current_state = EnemyStates.Idle
	else:
		current_state = EnemyStates.Wander
		wander_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
	enemy_state_timer.wait_time = randf_range(1.0, 3.0)

func start_slime_bounce():
	if slime_bounce_tween and slime_bounce_tween.is_running():
		return
	slime_bounce_tween = create_tween().set_loops()
	slime_bounce_tween.tween_property($SlimeSprite2D, "scale", Vector2(1.2, 0.8), 0.2).set_trans(Tween.TRANS_SINE)
	slime_bounce_tween.tween_property($SlimeSprite2D, "scale", Vector2(0.8, 1.2), 0.2).set_trans(Tween.TRANS_SINE)
	

func stop_slime_bounce():
	if slime_bounce_tween:
		slime_bounce_tween.kill()
		var reset_slime = create_tween()
		reset_slime.tween_property($SlimeSprite2D, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_QUAD)

func _on_attack_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player = area.get_parent()
		attack_cooldown.start()

func _on_attack_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		attack_cooldown.stop()

func _on_detection_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player = area.get_parent()
		current_state = EnemyStates.Chase

func _on_detection_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player = null
		current_state = EnemyStates.Idle
