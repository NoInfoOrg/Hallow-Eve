extends Button

var settings_open: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	settings_open = !settings_open
	var settings = get_node("Settings Screen")
	
	if settings_open:
		settings.show()
	elif not settings_open:
		settings.hide()
