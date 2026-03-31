extends Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	GlobalInformation.reset_player_information()
	get_tree().change_scene_to_file(get_tree().current_scene.scene_file_path)
