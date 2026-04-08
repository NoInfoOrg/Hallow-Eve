# INFO This is currently meant to house function definitions that multiple scripts and scenes might need
extends Node

# When testing with the SanityTest debugging in the UI, the last sanity icon empties at 2
const MINIMUM_SANITY = 2
const NO_MORE_SANITY_STRIKES = 0

# Player Sanity Bars
const FULL_STRIKE = 24
const HALF_STRIKE = FULL_STRIKE / 2
const BUFFER_BETWEEN_SANITY_ICONS = 12

const MAX_PLAYER_HEALTH_STRIKES = 3

var eve_health_strikes = 0
var willow_health_strikes = 0

func _ready():
	# Start the players out with full health (assuming this will be at the very start of the game)
	# We currently have 3 sanity icons, so I guess full health = 3 sanity icons full
	eve_health_strikes = MAX_PLAYER_HEALTH_STRIKES
	willow_health_strikes = MAX_PLAYER_HEALTH_STRIKES

func find_inventory(starting_node):
	#return find_node(starting_node, "UI/SharedInv/Inventory")
	return starting_node.get_tree().root.find_child("Inventory", true, false)

func find_slots_inventory_node(starting_node):
	#return find_node(starting_node, "UI/SharedInv/Inv")
	return starting_node.get_tree().root.find_child("Inv", true, false)

func find_player_one_sanity(starting_node):
	#return get_tree().root.find_child("P1Sanity", true, false)
	return starting_node.get_tree().root.find_child("P1Sanity", true, false)

func find_player_two_sanity(starting_node):
	#return get_tree().root.find_child("P2Sanity", true, false)
	return starting_node.get_tree().root.find_child("P2Sanity", true, false)

func find_game_over_screen(starting_node):
	#return find_node(starting_node, "Game Over Screen")
	return starting_node.get_tree().root.find_child("Game Over Screen", true, false)

# maybe defunct
func find_node(starting_node, node_path):
	var root = get_tree().root.get_child(0)
	
	var found_node = null
	var current_node = starting_node.get_node(".")
	
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
		found_node = current_node.get_node(node_path)
		if found_node != null:
			break
		
		# Go to the parent node of the current node we are at
		current_node = current_node.get_node("..")
		safetyIndex += 1
	
	return found_node

func deal_strike_damage_to_player(starting_node, player_name, damage_in_strikes):
	# Assuming that, previously in the code, we sent player_name to be "Eve - P1" or "Willow - P2"
	if player_name == "Eve - P1":
		var eve_sanity_node = find_player_one_sanity(starting_node)
		eve_health_strikes = decrease_sanity(eve_sanity_node, damage_in_strikes, eve_health_strikes)
		
		#print("NEW EVE BUFFER HEALTH IS: ")
		#print(eve_health_strikes)
	
	elif player_name == "Willow - P2":
		var willow_sanity_node = find_player_two_sanity(starting_node)
		willow_health_strikes = decrease_sanity(willow_sanity_node, damage_in_strikes, willow_health_strikes)
	
		#print("NEW WILLOW BUFFER HEALTH IS: ")
		#print(willow_health_strikes)
	
	else:
		print("global_information.gd : deal_strike_damage_to_player() : player_name is not Eve - P1 or Willow - P2")
	
	if eve_health_strikes == 0 or willow_health_strikes == 0:
		print("GAME OVER")
		on_game_over(starting_node)

func decrease_sanity(sanity_node, damage_in_strikes, player_health_strikes):
	var damage = damage_in_strikes * FULL_STRIKE
	
	# If a player reaches 0 sanity
	#if sanity_node.value - damage <= MINIMUM_SANITY:
	if player_health_strikes - damage_in_strikes <= NO_MORE_SANITY_STRIKES:
		sanity_node.value = 0
		return NO_MORE_SANITY_STRIKES
	
	sanity_node.value -= damage
	
	var prev_strikes = player_health_strikes
	player_health_strikes -= damage_in_strikes
	
	# If the player's sanity dorps below a sanity icon, since there is a buffer between one...
	# ...sanity icon and another, move the sanity value past that buffer
	if ((prev_strikes / 1) - (player_health_strikes / 1) > 0):
		sanity_node.value -= BUFFER_BETWEEN_SANITY_ICONS
	
	return player_health_strikes

func insta_defeat_player(starting_node, player_name):
	var insta_defeat_strike_amount = null
	
	if player_name == "Eve - P1":
		insta_defeat_strike_amount = eve_health_strikes
	
	elif player_name == "Willow - P2":
		insta_defeat_strike_amount = willow_health_strikes
	
	else:
		print("insta_defeat_player : player_name is not Eve - P1 or Willow - P2")
		return
	
	deal_strike_damage_to_player(starting_node, player_name, insta_defeat_strike_amount)

func on_game_over(starting_node):
	var game_over_screen = find_game_over_screen(starting_node)
	if game_over_screen == null:
		print("game over screen not found")
		return
	
	var defeat_message = game_over_screen.get_node("Control/Panel/VBoxContainer/Defeat Message")
	print(get_defeat_message())
	defeat_message.text = get_defeat_message()
	
	game_over_screen.show()

func get_defeat_message() -> String:
	const EVE_RAN_OUT_OF_SANITY_MESSAGE = "Eve ran out of sanity!"
	const WILLOW_RAN_OUT_OF_SANITY_MESSAGE = "Willow ran out of sanity!"
	
	if eve_health_strikes <= 0:
		return EVE_RAN_OUT_OF_SANITY_MESSAGE
	
	elif willow_health_strikes <= 0:
		return WILLOW_RAN_OUT_OF_SANITY_MESSAGE
	
	else:
		return ""

func reset_player_information():
	eve_health_strikes = MAX_PLAYER_HEALTH_STRIKES
	willow_health_strikes = MAX_PLAYER_HEALTH_STRIKES
