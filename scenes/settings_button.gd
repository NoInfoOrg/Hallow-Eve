extends Button

var settings_screen_is_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var settings_screen = get_node("CanvasLayer/Settings Screen")
	settings_screen.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	var settings_screen = get_node("CanvasLayer/Settings Screen")
	
	if settings_screen_is_open:
		settings_screen.hide()
		settings_screen_is_open = false
	else:
		settings_screen.show()
		settings_screen_is_open = true
