# INFO ctrl + left click the Player keyword vv to view the Player implementation
extends Player
var hold_inv = Inv.new()
func _ready():
	move_left_action = "P2Left"
	move_right_action = "P2Right"
	move_up_action = "P2Up"
	move_down_action = "P2Down"
	grab_left_action = "Willow_Left_PickUp"
	grab_right_action = "Willow_Right_PickUp"
	idle_left = "Willow_Left"
	idle_right = "Willow_Right"
	idle_up = "Willow_Up"
	idle_down = "Willow_Down"
	walk_left = "Willow_Left_Walking"
	walk_right = "Willow_Right_Walking"
	walk_up = "Willow_Up_Walking"
	walk_down = "Willow_Down_Walking"
	take_damage = "Willow_Damage_FullTo2-3"
	push_left = "Willow_Left_Push"
	push_right = "Willow_Right_Push"
	open = "P2Grab"

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
		print("item name: ", item.name)
		var path = "res://scenes/" + item.name + ".tscn"
		print("path: ", path)
		if ResourceLoader.exists(path):
			var dropped = load(path).instantiate()
			# offset to Willow's titanic height
			dropped.z_index = -5
			dropped.global_position = global_position + Vector2(0,10)

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
