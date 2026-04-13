extends Node2D

var music_node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_node = GlobalInformation.find_music_node(self)
	
	var main_menu_theme = music_node.get_node("Ambient Music/Test Hur Hur Hur")
	main_menu_theme.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
