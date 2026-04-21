extends BaseButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	GlobalInformation.is_in_main_menu = false
	GlobalInformation.toggle_main_menu_music()
	get_tree().change_scene_to_file("res://scenes/level_1_scene.tscn")
