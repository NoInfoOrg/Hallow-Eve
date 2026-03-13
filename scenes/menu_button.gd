extends Node2D

@onready var menu = $"MenuButton/Menu"
var menu_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("MenuButton"):
		menu_open = !menu_open
		if menu_open:
			menu.show()
		else:
			menu.hide()
		
		
