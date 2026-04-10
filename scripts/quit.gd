extends Button

var quit_unpressed = preload("res://assets/ui elements/settings/Settings_ExitButton.png")
var quit_pressed = preload("res://assets/ui elements/settings/Settings_ExitButton-Pressed.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = quit_unpressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_button_down() -> void:
	icon = quit_pressed

func _on_button_up() -> void:
	icon = quit_unpressed
