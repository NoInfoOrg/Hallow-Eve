extends Area2D

# INFO Inspired by Christopher Horhota's collectible.gd code
var players_detected = []

# The rotation direction will be clockwise by default for now
@export_enum("Clockwise", "Counterclockwise") var rotate_direction: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# NOTE The idea is that I tried having a collision shape for the front of the mirror, and a
	# collision shape for the back of the mirror. I started out by deactivating the back side
	# collision so the light rays can all collide with the front side collision, and then
	# reactivate the back side collision. As a result, ideally, any light ray that collided with
	# the front side collision from the back of the mirror would now be inside the back side
	# collision shape, and would essentially be invalid and would not produce subsequent
	# reflections, meaning that only the light rays that collided with the mirror from the front
	# side would have valid reflections.
	get_node("Back Side Collision").disabled = true

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
