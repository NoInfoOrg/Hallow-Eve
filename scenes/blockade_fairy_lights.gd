extends StaticBody2D

var totalReqsToOpen: int = 3
var completedReqs: int = 0
@onready var fairyLightSprite = $FairyLightSprite
@onready var blockadeCollider = $BlockadeCollider
var blockadeOpen = false
var blockadeMoveDuration = 1.5
var blockadeFadeDuration = 0.8
var blockadeMoveDistance = -200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	remove_blockade()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func req_met():
	pass
	#if blockadeOpen: 
		#return
	#completedReqs += 1
	#if completedReqs >= totalReqsToOpen:
		#remove_blockade()
	

func remove_blockade():
	blockadeOpen = true
	blockadeCollider.set_deferred("disabled", true)
	var tweenEffect = get_tree().create_tween()
	tweenEffect.tween_property(self, "position:y", position.y + blockadeMoveDistance, blockadeMoveDuration).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tweenEffect.parallel().tween_property(self, "scale:y", 0.0, blockadeMoveDuration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tweenEffect.tween_property(self, "modulate:a", 0.0, blockadeFadeDuration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tweenEffect.tween_callback(queue_free)
