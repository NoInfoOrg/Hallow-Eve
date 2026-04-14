extends Node2D

var return_button = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	return_button = get_node("Control/Panel/VBoxContainer 2/Return")
	return_button.back_to_menu.connect(_on_return_to_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_return_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
