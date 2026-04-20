extends PointLight2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

func play_sound():
	var fizzle = get_tree().current_scene.find_child("Fizzle", true, false)
	fizzle.play()
func play_sound2():
	var fizzle2 = get_tree().current_scene.find_child("Fizzle2", true, false)
	fizzle2.play()
	
func fizzle_out():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "energy", 2.5, 0.8)
	tween.tween_property(self, "energy", 1.2, 0.8)
	tween.tween_callback(play_sound)
	tween.tween_property(self, "energy", 0, 0.8)
	
func fizzle_out2():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "energy", 1.2, 0.4)
	tween.tween_callback(play_sound2)
	tween.tween_property(self, "energy", 0, 2)
