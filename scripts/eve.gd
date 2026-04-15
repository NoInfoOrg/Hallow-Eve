# INFO ctrl + left click the Player keyword vv to view the Player implementation
extends Player
var hold_inv = Inv.new()

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
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("P1Drop"):
		drop()
func hold(holdable):
	
	if hold_inv.get_inv_size() != 0:
		print("ERROR already holding: ", hold_inv.items[0].name)
		return false
	else:
		hold_inv.add_item(holdable)
		print("Holding:", holdable.name)
		return true
func drop():
	if hold_inv.items.size() == 1:
		var item = hold_inv.items[0]
		hold_inv.items.clear()
		# notes for Nicky :D...so load the scene		
		var path = "res://scenes/" + item.name + ".tscn"
		if ResourceLoader.exists(path):
			var dropped = load(path).instantiate()
			# offset the position to Eve's height
			dropped.z_index = -5
			dropped.global_position = global_position + Vector2(0,10)
			get_parent().add_child(dropped)
