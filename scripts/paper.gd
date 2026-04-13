extends Area2D

# INFO Shoutout Chris for the collectibles.gd which this code uses a lot of!
var players_detected = []

signal paper_viewed;

func _ready():
	# INFO Shoutout Chris that's him
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)

func _process(delta: float):
	for player in players_detected:
		if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
			paper_viewed.emit()
			break
		elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
			paper_viewed.emit()
			break

# INFO Shoutout Chris
func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		if body not in players_detected:
			players_detected.append(body)

func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)
