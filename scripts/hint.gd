extends Area2D

# INFO Shoutout Nick for the shapes_paper.gd fr
var players_detected = []
var hint_opened = false

var count : int
@export var homework: Node2D
@onready var hintDisplay = get_node("CanvasLayer/hint")

var currPlayer = null

func _ready():
	# INFO Shoutout Chris that's him
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)

func _process(delta: float):
	for player in players_detected:
		if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
			currPlayer = "Eve"
			interact_with_hint()
			break
		elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
			currPlayer = "Willow"
			interact_with_hint()
			break

# INFO Shoutout Chris
func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		if body not in players_detected:
			players_detected.append(body)

func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)

func interact_with_hint():

	
	if not hint_opened:
		show_hint()
		
		get_tree().paused = true

		hint_opened = true
	else:
		hintDisplay.hide()
		hint_opened = false
		get_tree().paused = false
		

func show_hint():
	hintDisplay.visible = true
	hintDisplay.show()
