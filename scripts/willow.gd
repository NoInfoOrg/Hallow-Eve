# INFO ctrl + left click the Player keyword vv to view the Player implementation
extends Player
var hold_inv = Inv.new()
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
func hold(holdable):
	if hold_inv.get_inv_size() != 0:
		print("ERROR already holding: ", hold_inv.items[0].name)
		return false
	else:
		hold_inv.add_item(holdable)
		return true
		
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("P2Drop"):
			drop()
		
func drop():
	if hold_inv.items.size() == 1:
		var item = hold_inv.items[0]
		hold_inv.items.clear()		
		var path = "res://scenes/" + item.name + ".tscn"
		if ResourceLoader.exists(path):
			var dropped = load(path).instantiate()
			# offset to Willow's titanic height
			dropped.z_index = -5
			dropped.global_position = global_position + Vector2(25,225)
			get_parent().add_child(dropped)
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
