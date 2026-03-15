extends Node2D

@onready var menu = $"../UI/MenuButton/CanvasLayer"
var menu_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MenuButton"):
		menu_open = !menu_open
		#var menu = get_node("../UI/MenuButton/Menu")
		var menu = get_node("Menu")
		if menu_open:
			get_tree().paused = true
			menu.show()
		else:
			get_tree().paused = false
			menu.hide()
			
			var settings = get_node("Menu/Control/Panel/VBoxContainer/Settings")
			settings.settings_open = false
			settings.get_node("Settings Screen").hide()

func _on_resume_pressed() -> void:
	var menu = get_node("Menu")
	menu.hide()
	menu_open = false
	
	get_tree().paused = false
