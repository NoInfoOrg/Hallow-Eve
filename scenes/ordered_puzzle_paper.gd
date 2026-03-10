extends Area2D

# INFO Shoutout Chris for the collectibles.gd which this code uses a lot of!
var players_detected = []
var note_opened = false

signal shapes_homework_viewed;

func _ready():
	# INFO Shoutout Chris that's him
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)

func _process(delta: float):
	for player in players_detected:
		if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
			interact_with_note("Eve")
			break
		elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
			interact_with_note("Willow")
			break

# INFO Shoutout Chris
func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		if body not in players_detected:
			players_detected.append(body)

func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)

func interact_with_note(player):
	var note = get_node("CanvasLayer/Ordered Puzzle Clue")
	
	if not note_opened:
		show_note(note, player)
		note_opened = true
	else:
		note.hide()
		note_opened = false

func show_note(note, player):
	# Show the default version by default
	var note_sprite = note.get_node("Versions")
	note_sprite.play("default")
	
	# Change the version based on if Eve or Willow opened it
	if player == "Eve":
		note_sprite.play("Eve")
	
	elif player == "Willow":
		note_sprite.play("Willow")
	
	note.show()
