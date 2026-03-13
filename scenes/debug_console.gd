# INFO Source: https://www.youtube.com/watch?v=aaFDnnrTSGg

extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var label: Label = $label

var debuggingWindowIsOpen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	get_node("CanvasLayer/Console Commands").hide()
	
	line_edit.text_submitted.connect(_on_LineEdit_text_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# INFO Ctrl + D to open the debugging menu
	if Input.is_action_just_pressed("ToggleDebuggingWindow"):
		if (!debuggingWindowIsOpen):
			show()
			get_node("CanvasLayer/Console Commands").show()
			debuggingWindowIsOpen = true
		else:
			hide()
			get_node("CanvasLayer/Console Commands").hide()
			debuggingWindowIsOpen = false

func _on_LineEdit_text_entered(new_text):
	#print(new_text)
	
	if new_text == "test_environment":
		get_tree().change_scene_to_file("res://scenes/movement_cont.tscn")
		return
		
	if new_text == "level_1":
		get_tree().change_scene_to_file("res://scenes/level_1_scene.tscn")
		return
	
	if new_text == "level_2":
		get_tree().change_scene_to_file("res://scenes/level_2_scene.tscn")
		return
	
	if new_text == "general_lighting_test":
		get_tree().change_scene_to_file("res://scenes/light_testing_environment.tscn")
		return
	
	if new_text == "light_ray_puzzle_test":
		get_tree().change_scene_to_file("res://scenes/light_ray_puzzle_testing_environment.tscn")
		return
		
	if new_text == "button_puzzle_test":
		get_tree().change_scene_to_file("res://scenes/button_puzzle_testing_environment.tscn")
		return
	
	if new_text == "blanket_ghost_test":
		get_tree().change_scene_to_file("res://scenes/blanket_ghost_enemy_testing_environment.tscn")
		return
