extends Area2D

# INFO Shoutout Chris for the collectibles.gd which this code uses a lot of!
var players_detected = []
var homework_opened = false

signal hw_completed(hw_type)
signal shapes_homework_viewed;
var count : int
@onready var homework = get_node("CanvasLayer/Homework")
@onready var answer_box = get_node("CanvasLayer/Answer Text Box")
@export var type : String
@export var answer : String

func _ready():
	# INFO Shoutout Chris that's him
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)
	count = 0


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
	#var homework = get_node("CanvasLayer/Homework")
	#var answer = get_node("CanvasLayer/Answer Text Box")
	
	if not homework_opened:
		show_homework(homework)
		answer_box.show()
		homework_opened = true
	else:
		homework.hide()
		answer_box.hide()
		homework_opened = false

func show_homework(homework):
	# Show the default version by default
	var homework_sprite = homework.get_node("Versions")
	homework_sprite.play("default")
	
	# If the players have the black light, show the black light version
	var inventory = get_node("../../UI/SharedInv/Inventory")
	for item in inventory.items:
		if item.name == "Black Light Flashlight Item":
			homework_sprite.play("under_black_light")
	
	homework.show()

func check_answer():
	if answer_box.currentContent == answer:
		
		# check if it's shape hw or math hw by the answer
		if answer == "0":
			hw_completed.emit("math")
		elif answer == "11":
			hw_completed.emit("shapes")
		homework.hide()
		answer_box.hide()
		homework_opened = false
		queue_free()

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
