extends Node2D

@onready var menu = $"../UI/MenuButton/CanvasLayer"
var menu_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MenuButton"):
		menu_open = !menu_open
		#var menu = get_node("../UI/MenuButton/Menu")
		var menu = get_node("Menu")
		if menu_open:
			menu.show()
		else:
			menu.hide()
		
		
