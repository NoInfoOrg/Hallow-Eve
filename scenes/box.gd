extends Area2D

var players_detected = []
var curr_player = null
signal updated_guess
@onready var item_pic = get_node("../TextureRect")
var hold_item
var full = false
@export var Box_Index: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# box starts off empty
	item_pic.visible = false
	body_entered.connect(body_entry)
	body_exited.connect(body_exit)
	# connect to vbox container to detect the signal
	var overlord = get_node("../../../VBoxContainer")
	if overlord:
		overlord.connect("empty_box", empty_da_box)

func _process(delta: float) -> void:
		for player in players_detected:
			if not full:
				if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
					place(player)
					break
				elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
					place(player)
					break
			else:
				if Input.is_action_just_pressed("P1Grab") and player.name == "Eve - P1":
					pickup_box(player)
					break
				elif Input.is_action_just_pressed("P2Grab") and player.name == "Willow - P2":
					pickup_box(player)
					break
func body_entry(body):
	if body.name == "Eve - P1" or body.name == "Willow - P2":
		if body not in players_detected:
			players_detected.append(body)
func body_exit(body):
	if body in players_detected:
		players_detected.erase(body)
func place(player):
	if player.hold_inv.items.size() != 0 and not full:
		updated_guess.emit(Box_Index, player.hold_inv.items[0].name)
		# display the item dropped
		item_pic.texture = player.hold_inv.items[0].texture
		item_pic.visible = true
		item_pic.scale = Vector2(.25,.25)
		hold_item = player.hold_inv.items[0]
		player.hold_inv.items.clear()
		full = true
	elif full:
		print("bro it's full")

func empty_da_box(index):
	if index == Box_Index:
		full = false

func pickup_box(player):
	if not full:
		return
	# so good it got a sequel :O
	var overlord2 = get_node("../../../VBoxContainer")
	if overlord2.not_green(Box_Index):
		player.hold(hold_item)
		hold_item = ""
		overlord2.curr[Box_Index] = ""
		overlord2.rects[Box_Index].color = Color("#aa6b07")
		item_pic.visible = false
		full = false
	

		
