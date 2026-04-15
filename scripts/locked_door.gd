extends StaticBody2D

# Inventory
var inventory = null

# For normal room doors (presumably)
@export var required_key: Area2D = null
var key_needed = false
var required_key_name = ""

# For the button puzzles
@export var connected_buttons: Array[Area2D]
@export var synced_buttons_needed = false
@export var ordered_buttons_needed = false
@export var required_buttons: Array[Area2D]

var pressed_buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# homeboy so good it got the trilogy 
	var overlord3 = get_node("../VBoxContainer")
	# they're selling out on this one fr
	var overlord4 = get_node("../GridContainer")
	if overlord3:
		print("homeboy spotted")
		overlord3.connect("puzzle_complete", on_puzzle_completion)
	if overlord4:
		print("homeboy spotted")
		overlord4.connect("puzzle_complete", on_puzzle_completion)
	
	var paper = get_tree().current_scene.find_child("Shapes Paper", true, false)
	var paper2 = get_tree().current_scene.find_child("Math Paper", true, false)
	if paper and paper2:
		print("lol")
		paper.connect("correc", on_paper_correct)
	if required_key != null:
		key_needed = true
		required_key_name = required_key.name
		print(required_key_name)
	
	for button in connected_buttons:
		if button:
			button.connect("button_object_emitted", on_button_object_emitted)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# For now, we assume that every door that needs a key will have a key connected to the door
	# As a result, the required_key being changed to null means the key was picked up!
	if key_needed:
		# Checks for the required key and changes the wreath sprite accordingly
		check_for_key()
	
	elif synced_buttons_needed:
		check_synced_buttons()
	
	elif ordered_buttons_needed:
		check_ordered_buttons()

func check_for_key():
	# Try to find the inventory first
	if inventory == null:
		inventory = GlobalInformation.find_inventory(self)
	
	# If the inventory is still not found
	if inventory == null:
		print("locked_door.gd : check_for_key() : inventory not found")
		return
	
	var wreath = get_node("Wreath")
	
	for item in inventory.items:
		if item.name == required_key_name:
			wreath.play("glow")
			return true
	
	wreath.play("no glow")
	return false

func check_synced_buttons():
	var all_buttons_pressed = true
	
	# Check if all required buttons have been pressed
	for button in required_buttons:
		if not button.button_pressed:
			all_buttons_pressed = false
	
	# If all required buttons are pressed, open the door
	if all_buttons_pressed:
		# Change the door image to be opened
		# get_node("Door").play("open")
		if has_node("OpenDoor"):
			get_node("OpenDoor").visible = true
			
		if has_node("ClosedDoor"):
			get_node("ClosedDoor").visible = false
		
		# Change the door collision so players can enter the door
		get_node("Closed Door Collision").set_deferred("disabled", true)

func check_ordered_buttons():
	# Only check the order of the buttons when we have the required sequence size
	if pressed_buttons.size() != required_buttons.size():
		#print("We are NOT ready to check the button order")
		return
	
	#print("We are ready to check the button order")
	var buttons_are_in_order = true
	
	for i in range(0, required_buttons.size()):
		if required_buttons[i] != pressed_buttons[i]:
			buttons_are_in_order = false
	
	if buttons_are_in_order:
		# Change the door image to be opened
		if has_node("OpenDoor"):
			get_node("OpenDoor").visible = true
			
		if has_node("ClosedDoor"):
			get_node("ClosedDoor").visible = false
		# Change the door collision so players can enter the door
		get_node("Closed Door Collision").set_deferred("disabled", true)
	
	# Reset the sequence
	pressed_buttons.clear()

func on_button_object_emitted(button):
	#print("Added:")
	#print(button)
	#print("---")
	pressed_buttons.append(button)
	
func on_puzzle_completion():
	# shoutout to Nick for opening this door (a gentelman fr)
		# Change the door image to be opened

		if has_node("OpenDoor"):

			get_node("OpenDoor").visible = true
			
		if has_node("ClosedDoor"):
			print("closed door found")
			get_node("ClosedDoor").visible = false
		
		# Change the door collision so players can enter the door
		get_node("Closed Door Collision").set_deferred("disabled", true)

func on_paper_correct():
	var key = get_node("../key")
	if key:
		key.visible = true
		key.monitoring = true
		key.monitorable = true
