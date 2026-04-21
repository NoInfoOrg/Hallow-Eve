extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export var damage = 0.5

var can_attack: bool = true
var player_in_range: CharacterBody2D = null
var player_detected: CharacterBody2D = null


func _physics_process(delta: float) -> void:
	if player_in_range:
		mimic_attack()
	elif player_detected:
		$AnimationPlayer.play("BookcaseMimic_Idle-Curious")
	else:
		$AnimationPlayer.play("BookcaseMimic_Idle-Lurking")

func mimic_attack():
	if not $AttackTimer.is_stopped() or $AnimationPlayer.is_playing():
		return
	can_attack = false
	$AnimationPlayer.play("BookcaseMimic_Attack")
	await $AnimationPlayer.animation_finished
	if is_instance_valid(player_in_range):
		GlobalInformation.deal_strike_damage_to_player(self, player_in_range.name, damage)
		$AttackTimer.start()
	can_attack = true

func _on_detection_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player_detected = area.get_parent()

func _on_detection_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player_detected = null


func _on_attack_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player_in_range = area.get_parent()


func _on_attack_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("HurtBox"):
		player_in_range = null
