extends StaticBody2D

@export var connected_buttons: Array[Area2D]

@export var synced_buttons_needed = false
@export var ordered_buttons_needed = false
@export var required_buttons: Array[Area2D]

var pressed_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button in connected_buttons:
		button.connect("button_object_emitted", on_button_object_emitted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if synced_buttons_needed:
		check_synced_buttons()
	
	elif ordered_buttons_needed:
		check_ordered_buttons()

func check_synced_buttons():
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

func check_ordered_buttons():
	# Only check the order of the buttons when we have the required sequence size
	if pressed_buttons.size() != required_buttons.size():
		#print("We are NOT ready to check the button order")
		return
	
	#print("We are ready to check the button order")
	var buttons_are_in_order = true
	
	for i in range(0, required_buttons.size()):
		if required_buttons[i] != pressed_buttons[i]:
			buttons_are_in_order = false
	
	if buttons_are_in_order:
		# Change the door image to be opened
		get_node("Door").play("open")
		
		# Change the door collision so players can enter the door
		get_node("Closed Door Collision").set_deferred("disabled", true)
	
	# Reset the sequence
	pressed_buttons.clear()

func on_button_object_emitted(button):
	#print("Added:")
	#print(button)
	#print("---")
	pressed_buttons.append(button)
