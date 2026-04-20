extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	if GlobalInformation.current_scene == "level_1_scene":
		GlobalInformation.saved_scene = GlobalInformation.scenes.LEVEL_1
		
	elif GlobalInformation.current_scene == "level_2_scene":
		GlobalInformation.saved_scene = GlobalInformation.scenes.LEVEL_2
		
	elif GlobalInformation.current_scene == "level_3_scene":
		GlobalInformation.saved_scene = GlobalInformation.scenes.LEVEL_3
	
	GlobalInformation.is_in_main_menu = true
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
