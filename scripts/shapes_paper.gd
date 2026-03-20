extends Area2D

# INFO Shoutout Chris for the collectibles.gd which this code uses a lot of!
var players_detected = []
var homework_opened = false

signal shapes_homework_viewed;

func _ready():
	# INFO Shoutout Chris that's him
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)

func _process(delta: float):
	if homework_opened:
		check_answer()
	
	for player in players_detected:
		if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
			interact_with_homework()
			break
		elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
			interact_with_homework()
			break

# INFO Shoutout Chris
func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		if body not in players_detected:
			players_detected.append(body)

func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)

func interact_with_homework():
	var homework = get_node("CanvasLayer/Shapes Homework")
	var answer = get_node("CanvasLayer/Answer Text Box")
	
	if not homework_opened:
		show_homework(homework)
		answer.show()
		homework_opened = true
	else:
		homework.hide()
		answer.hide()
		homework_opened = false

func show_homework(homework):
	# Show the default version by default
	var homework_sprite = homework.get_node("Versions")
	homework_sprite.play("default")
	
	# If the players have the black light, show the black light version
	var inventory = get_node("../UI/SharedInv/Inventory")
	for item in inventory.items:
		if item.name == "Black Light Flashlight Item":
			homework_sprite.play("under_black_light")
	
	homework.show()

func check_answer():
	var correct_answer = "11"
	
	var homework = get_node("CanvasLayer/Shapes Homework")
	var answer = get_node("CanvasLayer/Answer Text Box")
	
	if answer.currentContent == correct_answer:
		print("CORRECT ANSWER !!!")
		homework.hide()
		answer.hide()
		homework_opened = false
