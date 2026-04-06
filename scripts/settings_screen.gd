extends CanvasLayer

@onready var Master_Volume_Slider: HScrollBar = $"Control/Panel/VBoxContainer/Master Volume Slider"
@onready var Music_Volume_Slider: HScrollBar = $"Control/Panel/VBoxContainer/Music Volume Slider"

var current_master_volume = null
var current_music_volume = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Master_Volume_Slider.value = 1
	Music_Volume_Slider.value = 1
	current_master_volume = Master_Volume_Slider.value
	current_music_volume = Music_Volume_Slider.value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If the master volume changes, change the volumes of every audio node
	# Otherwise, we don't need to continuously call reduce_master_volumes()
	if current_master_volume != Master_Volume_Slider.value:
		current_master_volume = Master_Volume_Slider.value
		reduce_volumes(get_tree().root)
	
	if current_music_volume != Music_Volume_Slider.value:
		current_music_volume = Music_Volume_Slider.value
		reduce_volumes(get_tree().root)

func reduce_volumes(starting_node):
	for child_node in starting_node.get_children():
		if child_node is AudioStreamPlayer:
			if child_node.is_in_group("Music"):
				child_node.set_volume_linear(current_master_volume * current_music_volume)
			
			else:
				child_node.set_volume_linear(current_master_volume)
		
		reduce_volumes(child_node)
