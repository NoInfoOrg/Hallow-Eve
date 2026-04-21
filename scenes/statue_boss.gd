extends StaticBody2D

@export var moveDistance: float = 50.0
@export var moveDuration: float = 1
var statueMoved: bool = false

func _ready() -> void:
	get_node("Statue Foot Collider").set_deferred("disabled", true)


func _on_grid_container_statue_puzzle_complete() -> void:
	if statueMoved:
		return
	statueMoved = true
	get_node("Statue Collider").set_deferred("disabled", true)
	get_node("Statue Foot Collider").set_deferred("disabled", false)
	var tweenEffect = create_tween()
	tweenEffect.tween_property(self, "position:x", position.x + 2, 0.1)
	tweenEffect.tween_property(self, "position:x", position.x - 2, 0.1)
	tweenEffect.tween_property(self, "position:x", position.x, 0.1)
	tweenEffect.tween_property(self, "position:y", position.y - moveDistance, moveDuration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
