extends Button

var settings_open: bool = false

var exit_settings_button = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_settings_button = get_node("Settings Screen/Control/Panel/VBoxContainer/Back to Menu")
	exit_settings_button.back_to_menu.connect(_on_return_to_main_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	settings_open = !settings_open
	var settings = get_node("Settings Screen")
	
	if settings_open:
		settings.show()

func _on_return_to_main_menu() -> void:
	settings_open = !settings_open
	var settings = get_node("Settings Screen")
	settings.hide()
