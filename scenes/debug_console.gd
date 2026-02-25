# INFO Source: https://www.youtube.com/watch?v=aaFDnnrTSGg

extends Node2D

@onready var line_edit: LineEdit = $LineEdit
@onready var label: Label = $label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	line_edit.text_submitted.connect(_on_LineEdit_text_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_LineEdit_text_entered(new_text):
	#print(new_text)
	
	if new_text == "test_environment":
		get_tree().change_scene_to_file("res://scenes/movement_cont.tscn")
		
	if new_text == "level_1":
		get_tree().change_scene_to_file("res://scenes/level_1_scene.tscn")
