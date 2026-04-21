extends Area2D

@export var item_info: Item
@export var is_holding: bool = false
@onready var key = $key
@onready var holdable = $food
@export var is_tag : bool = false
var players_detected = []
var curr_player = null
var label : Label
var bg : Panel

func _ready():
	if is_holding:
		if item_info and item_info.texture:
			holdable.texture = item_info.texture
	if item_info and item_info.texture and key:
		key.texture = item_info.texture
	
	if name and item_info:
		item_info.name = name
	
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)
	if is_tag:
		label = get_node("Label")
		bg = get_node("Panel")
		label.visible = false
		bg.visible = false


func _process(delta: float):
	for player in players_detected:
		if is_tag:
			label.visible = true
			bg.visible = true
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
		if is_tag:
			label.visible = false
			bg.visible = false

func pickup(player):
	if item_info:
		if is_holding:
			if player.hold(item_info):
				queue_free()
				print("Player: ", player.name, " is holding ", item_info.name)
			else:
				print("Player holding something")
			return
		#var inv = player.get_node("../UI/SharedInv/Inventory")
		var inv = GlobalInformation.find_inventory(self)
		if inv == null:
			print("inventory not found in collectibles.gd... returning early in pickup()")
			return
		
		if inv:
			inv.add_item(item_info)
			var pickup  = get_tree().current_scene.find_child("Pickup", true, false)
			pickup.play()
			queue_free()
