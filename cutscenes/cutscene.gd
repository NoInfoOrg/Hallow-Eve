extends Control

@onready var vid = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vid.finished.connect(load_level)
	vid.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func load_level():
	get_tree().change_scene_to_file("res://scenes/level_1_scene.tscn")
