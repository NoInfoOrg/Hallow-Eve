extends Button

var unpressed_texture = preload("res://assets/ui elements/settings/volume bar/Settings_VolumeArrow_Right.png")
var pressed_texture = preload("res://assets/ui elements/settings/volume bar/Settings_VolumeArrow_Right-Pressed.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = unpressed_texture

func _on_button_down() -> void:
	icon = pressed_texture

func _on_button_up() -> void:
	icon = unpressed_texture

func _on_pressed() -> void:
	# So far, we have volume_life_arrow.gd in a button node under either:
	# 	Master Volume
	# 	Music Volume
	var parent_node = get_parent()
	
	if parent_node.name == "Master Volume":
		GlobalInformation.increase_master_volume()
		
		# Assuming that the valid volumes are 0.1, 0.2, ..., 1.0
		var volume_index = int(GlobalInformation.current_master_volume_linear * 10)
		parent_node.get_node("Volume Meter").play(str(volume_index))
	
	elif parent_node.name == "Music Volume":
		GlobalInformation.increase_music_volume()
		
		# Assuming that the valid volumes are 0.1, 0.2, ..., 1.0
		var volume_index = int(GlobalInformation.current_music_volume_linear * 10)
		parent_node.get_node("Volume Meter").play(str(volume_index))
	
	else:
		print("volume_right_arrow.gd : unknown parent node. Returning...")
		return
