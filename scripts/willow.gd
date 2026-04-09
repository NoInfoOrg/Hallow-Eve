# INFO ctrl + left click the Player keyword vv to view the Player implementation
extends Player

func _ready():
	move_left_action = "P2Left"
	move_right_action = "P2Right"
	move_up_action = "P2Up"
	move_down_action = "P2Down"
	grab_action = "P2Grab"
	idle_left = "Willow_Left"
	idle_right = "Willow_Right"
	idle_up = "Willow_Up"
	idle_down = "Willow_Down"
	walk_left = "Willow_Left"
	walk_right = "Willow_Right"
	walk_up = "Willow_Up"
	walk_down = "Willow_Down"

# Storage (someone cooked here)
"""
extends CharacterBody2D

@export var player_id = 2
const SPEED = 300.0



func _physics_process(delta):
	var direction = get_direction()
	velocity = direction * SPEED
	
	move_and_slide()
func get_direction():
	match player_id:
		1: return Input.get_vector("P1Left", "P1Right", "P1Up", "P1Down")
		2: return Input.get_vector("P2Left", "P2Right", "P2Up", "P2Down")
		_: return Vector2.ZERO
"""
