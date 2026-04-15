extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalInformation.music_scene = GlobalInformation.scenes.LEVEL_3
	GlobalInformation.change_music()
