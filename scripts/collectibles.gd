extends Area2D

@export var item_info: Item
@onready var key = $key

var players_detected = []
var curr_player = null

func _ready():
	if item_info and item_info.texture:
		key.texture = item_info.texture
	
	if name:
		item_info.name = name
	
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)

func _process(delta: float):
	for player in players_detected:
		if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
			pickup(player)
			break
		elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
			pickup(player)
			break

func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		if body not in players_detected:
			players_detected.append(body)

func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)

func pickup(player):
	if item_info:
		#var inv = player.get_node("../UI/SharedInv/Inventory")
		var inv = find_inventory()
		if inv == null:
			print("inventory not found in collectibles.gd... returning early in pickup()")
			return
		
		if inv:
			inv.add_item(item_info)
			queue_free()

# Copied from playermv.gd and player2mv.gd
func find_inventory():
	var root = get_tree().root.get_child(0)
	
	var inventory = null
	var current_node = get_node(".")
	
	# Not really required, but basically limit the while loop to run up to 1000 times
	# Currently, I don't think our game is 1000 parent nodes deep (at the moment, it's around 5-10 usually?)
	const MAX_ITERATIONS = 1000
	var safetyIndex = 0
	
	while safetyIndex < MAX_ITERATIONS:
		#print(current_node.name)
		
		if current_node == root:
			break
		
		# get_node will either be null if the filepath at that moment doesn't exist...
		# ...or not null if the filepath exists!
		inventory = current_node.get_node("UI/SharedInv/Inventory")
		if inventory != null:
			break
		
		# Go to the parent node of the current node we are at
		current_node = current_node.get_node("..")
		safetyIndex += 1
	
	return inventory
