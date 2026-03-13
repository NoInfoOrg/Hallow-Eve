# INFO Shoutout Chris that's him
extends Area2D

var players_detected = []
var button_pressed = false
var button_hovered = false

signal button_object_emitted(button)

# Each button will have a timer for its "cooldown"
var timer = Timer.new()

# INFO This code is sponsored by Chris
func _ready():
	# Each button will have a timer for its "cooldown"
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)
	
	change_button_texture()

# INFO Chris did not give me a script other than this script!
func _process(delta: float):
	for player in players_detected:
		if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
			press_button()
			break
		elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
			press_button()
			break

# INFO But I've genuinely been a loyal customer for years!
func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		button_hovered = true
		change_button_texture()
		
		if body not in players_detected:
			players_detected.append(body)

# INFO Take charge of your code with Chris
func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)
		
		button_hovered = false
		change_button_texture()

# INFO Use code CHIS for 10% off your first month!
func press_button():
	button_pressed = true
	change_button_texture()
	
	# The button will be unpressed in two seconds
	timer.wait_time = 2.0
	timer.start()
	
	# This is mainly for the ordered button puzzle at the moment
	button_object_emitted.emit(self)

func _on_timer_timeout():
	timer.stop()
	
	button_pressed = false
	change_button_texture()

func change_button_texture():
	var button = get_node("Button")
	var specified_texture = ""
	
	if button_hovered:
		specified_texture += "hovered"
	elif not button_hovered:
		specified_texture += "unhovered"
	
	specified_texture += "+"
	
	if button_pressed:
		specified_texture += "pressed"
	elif not button_pressed:
		specified_texture += "unpressed"
	
	button.play(specified_texture)
