extends Node2D

# INFO Sources
# https://www.youtube.com/watch?v=Qs8oSGmhx-U

var box = preload("res://scenes/box.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_environment(Vector2(700, 300))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_to_environment(x_and_y_position):
	var instance = box.instantiate()
	instance.position = x_and_y_position
	instance.scale = Vector2(0.5, 0.5)
	add_child(instance)
