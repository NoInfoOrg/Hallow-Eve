# INFO ctrl + left click the Player keyword vv to view the Player implementation
extends Player

func _ready():
	move_left_action = "P1Left"
	move_right_action = "P1Right"
	move_up_action = "P1Up"
	move_down_action = "P1Down"
	grab_action = "P1Grab"
	idle_left = "Eve_Idle_A"
	idle_right = "Eve_Idle_D"
	idle_up = "Eve_Idle_W"
	idle_down = "Eve_Idle_S"
	walk_left = "Eve_Walk_A"
	walk_right = "Eve_Walk_D"
	walk_up = "Eve_Walk_W"
	walk_down = "Eve_Walk_S"
