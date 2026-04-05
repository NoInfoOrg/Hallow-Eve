extends Area2D

# INFO Inspired by Christopher Horhota's collectible.gd code
var players_detected = []

# The rotation direction will be clockwise by default for now
@export_enum("Clockwise", "Counterclockwise") var rotate_direction: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("P1Grab") and "Eve - P1" in players_detected:
		turn_mirror()
		return
	
	if Input.is_action_just_pressed("P2Grab") and "Willow - P2" in players_detected:
		turn_mirror()
		return

func _on_body_entered(body: Node2D) -> void:
	if body.name in ["Eve - P1", "Willow - P2"]:
		players_detected.append(body.name)

func _on_body_exited(body: Node2D) -> void:
	if body.name in ["Eve - P1", "Willow - P2"]:
		players_detected.erase(body.name)

func turn_mirror():
	# The rotation direction will be clockwise by default for now
	var rotation_amount_in_degrees = 30
	
	if rotate_direction == "Counterclockwise":
		rotation_amount_in_degrees *= -1
	
	rotation_degrees += rotation_amount_in_degrees
