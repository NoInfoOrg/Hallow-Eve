extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Assuming that the valid volumes are 0.1, 0.2, ..., 1.0
	var volume_index = int(GlobalInformation.current_master_volume_linear * 10)
	get_node("Volume Meter").play(str(volume_index))
