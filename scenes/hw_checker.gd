extends Node2D

@onready var paper_math = get_tree().current_scene.find_child("Math Paper", true, false)
@onready var paper_shapes = get_tree().current_scene.find_child("Shapes Paper", true, false)
@export var key : Area2D
var answer_key = {"math": false, "shapes": false}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	paper_math.connect("hw_completed", hw_completion)
	paper_shapes.connect("hw_completed", hw_completion)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func hw_completion(hw_type):
	answer_key[hw_type] = true
	if answer_key["shapes"] and answer_key["math"]:
		print("holy heck nuggets")
		key.visible = true
		key.monitoring = true
		key.monitorable = true
	
