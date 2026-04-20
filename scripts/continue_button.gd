extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalInformation.current_scene == "main_menu":
		disabled = true
	else:
		disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if GlobalInformation.saved_scene == GlobalInformation.scenes.LEVEL_1:
		get_tree().change_scene_to_file("res://scenes/level_1_scene.tscn")
		
	elif GlobalInformation.saved_scene == GlobalInformation.scenes.LEVEL_2:
		get_tree().change_scene_to_file("res://scenes/level_2_scene.tscn")
		
	elif GlobalInformation.saved_scene == GlobalInformation.scenes.LEVEL_3:
		get_tree().change_scene_to_file("res://scenes/level_3_scene.tscn")
