extends Node2D

var music_node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInformation.music_scene = GlobalInformation.scenes.MAIN_MENU

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
