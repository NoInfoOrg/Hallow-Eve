extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	var music_node = GlobalInformation.find_music_node(self)
	var main_menu_theme = music_node.get_node("Ambient Music/Main Music Halloween Theme")
	main_menu_theme.stop()
	
	GlobalInformation.is_in_main_menu = false
	get_tree().change_scene_to_file("res://scenes/level_1_scene.tscn")
