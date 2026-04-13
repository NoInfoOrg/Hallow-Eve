extends Area2D

# INFO Shoutout Chris for the collectibles.gd which this code uses a lot of!
var players_detected = []
var homework_opened = false

signal hw_completed(hw_type)
signal shapes_homework_viewed; # <=== bro is C++ coded 
var count : int
@export var homework: Node2D
@export var answer_box: Node2D
var line : LineEdit
@export var type : String
@export var answer : String
var currPlayer = null

func _ready():
	# INFO Shoutout Chris that's him
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)
	count = 0
	line = answer_box.get_node("LineEdit")
	
		


func _process(delta: float):
	if homework_opened and Input.is_action_just_pressed("P1Drop") and currPlayer == "Eve":
		check_answer()
	if homework_opened and Input.is_action_just_pressed("P2Drop") and currPlayer == "Willow":
		check_answer()
	for player in players_detected:
		if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
			currPlayer = "Eve"
			interact_with_homework()
			break
		elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
			currPlayer = "Willow"
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
	#var homework = get_node("CanvasLayer/Homework")
	#var answer = get_node("CanvasLayer/Answer Text Box")
	
	if not homework_opened:
		show_homework(homework)
		answer_box.show()
		get_tree().paused = true
		answer_box.process_mode = Node.PROCESS_MODE_ALWAYS
		if line:
			line.grab_focus()
		homework_opened = true
	else:
		homework.hide()
		answer_box.hide()
		homework_opened = false
		get_tree().paused = false
		

func show_homework(homework):
	var label = get_node("CanvasLayer/Answer Text Box/Label")
	if currPlayer == "Eve":
		label.text = "Type answer and press \"Q\" to submit"
	elif currPlayer == "Willow":
		label.text = "Type answer and press \"Shift\" to submit"
	# Show the default version by default
	var homework_sprite = homework.get_node("Versions")
	homework_sprite.play("default")
	
	# If the players have the black light, show the black light version
	var inventory = GlobalInformation.find_inventory(self)
	for item in inventory.items:
		if item.name == "Black Light Flashlight Item":
			homework_sprite.play("under_black_light")
	
	homework.show()

func check_answer():

	var curr = line.text
	#print(line.text[0:len(line.text-1)], " :) ", answer) what is this madness?
	if curr == answer:

		# check if it's shape hw or math hw by the answer
		if answer == "0":
			hw_completed.emit("math")
		elif answer == "11":
			hw_completed.emit("shapes")
		homework.hide()
		answer_box.hide()
		homework_opened = false
		queue_free()
		get_tree().paused = false
		return

	if homework_opened:
		var label = get_node("CanvasLayer/Answer Text Box/Label")
		
		if label:
			label.text = "Incorrect. Please try again."
			if line:	
				line.grab_focus()
				line.clear()			
			await get_tree().create_timer(1.5).timeout
			if currPlayer == "Eve":
				label.text = "Type answer and press \"Q\" to submit"
			elif currPlayer == "Willow":
				label.text = "Type answer and press \"Shift\" to submit"
			




				

# get it to work so that it can be entered after wrong answer
		
#func check_answer_math():
	#var correct_answer = "0"
	#var homework = get_node("CanvasLayer/Homework")
	#var answer = get_node("CanvasLayer/Answer Text Box")
	#
	#if answer.currentContent == correct_answer:
		#homework.hide()
		#answer.hide()
		#homework_opened = false
		#queue_free()
