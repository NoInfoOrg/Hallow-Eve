# INFO Source: https://www.youtube.com/watch?v=aaFDnnrTSGg

extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var label: Label = $label

var debuggingWindowIsOpen = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	get_node("CanvasLayer/Console Commands").hide()
	
	line_edit.text_submitted.connect(_on_LineEdit_text_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# INFO Ctrl + D to open the debugging menu
	if Input.is_action_just_pressed("ToggleDebuggingWindow"):
		if (!debuggingWindowIsOpen):
			get_tree().paused = true
			show()
			get_node("CanvasLayer/Console Commands").show()
			debuggingWindowIsOpen = true
		else:
			hide()
			get_node("CanvasLayer/Console Commands").hide()
			debuggingWindowIsOpen = false
			get_tree().paused = false

func _on_LineEdit_text_entered(new_text):
	#print(new_text)
	
	var valid_command = true
	var scene_path = ""
	
	if new_text == "test_environment":
		scene_path = "res://scenes/movement_cont.tscn"
		
	elif new_text == "level_1":
		scene_path = "res://scenes/level_1_scene.tscn"
	
	elif new_text == "level_2":
		scene_path = "res://scenes/level_2_scene.tscn"
	
	elif new_text == "general_lighting_test":
		scene_path = "res://scenes/light_testing_environment.tscn"
	
	elif new_text == "light_ray_puzzle_test":
		scene_path = "res://scenes/light_ray_puzzle_testing_environment.tscn"
		
	elif new_text == "button_puzzle_test":
		scene_path = "res://scenes/button_puzzle_testing_environment.tscn"
	
	elif new_text == "blanket_ghost_test":
		scene_path = "res://scenes/blanket_ghost_enemy_testing_environment.tscn"
	
	else:
		valid_command = false
	
	# If we entered a valid command, it would redirect us to a new scene at the moment
	# As a result, unpause the tree so we can run the scene
	if valid_command:
		get_tree().paused = false
		get_tree().change_scene_to_file(scene_path)
