extends Button

var resume_unpressed = preload("res://assets/ui elements/settings/Settings_Return.png")
var resume_pressed = preload("res://assets/ui elements/settings/Settings_Return-Pressed.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = resume_unpressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_down() -> void:
	icon = resume_pressed

func _on_button_up() -> void:
	icon = resume_unpressed
