extends StaticBody2D

@export var button_operated = false
@export var required_buttons: Array[Area2D]

# INFO: This script is currently not being used

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if button_operated:
		check_buttons()

func check_buttons():
	var all_buttons_pressed = true
	
	# Check if all required buttons have been pressed
	for button in required_buttons:
		if not button.button_pressed:
			all_buttons_pressed = false
	
	# If all required buttons are pressed, open the door
	if all_buttons_pressed:
		# Change the door image to be opened
		get_node("Door").play("open")
		
		# Change the door collision so players can enter the door
		get_node("Closed Door Collision").set_deferred("disabled", true)
