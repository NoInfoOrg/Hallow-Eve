extends Area2D

@export var item_info: Item
@onready var key = $key
var player_detected = false
var curr_player = null
func _ready():
	if item_info and item_info.texture:
		key.texture = item_info.texture
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)
func _process(delta: float):
	if player_detected and curr_player:
		if Input.is_action_just_pressed("P1Grab"):
			pickup(curr_player)
		elif Input.is_action_just_pressed("P2Grab"):
			pickup(curr_player)
			 
func body_entry(body):
	if body.name == "player" or body.name == "CharacterBody2D":
		player_detected = true
		curr_player = body
func body_exit(body):
	if body == curr_player:
		player_detected = false
		curr_player = null

func pickup(player):
	if item_info:
		var inv = player.get_node("/root/MovementCont/Inventory")
		if inv:
			inv.add_item(item_info)
			queue_free()
