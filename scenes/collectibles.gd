extends Area2D

@export var item_info: Item
@onready var key = $key

var players_detected = []
var curr_player = null

func _ready():
	if item_info and item_info.texture:
		key.texture = item_info.texture
	
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
		var inv = player.get_node("/root/MovementCont/Inventory")
		if inv:
			inv.add_item(item_info)
			queue_free()
