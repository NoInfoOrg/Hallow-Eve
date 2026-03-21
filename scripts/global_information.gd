# INFO This is currently meant to house function definitions that multiple scripts and scenes might need
extends Node

# When testing with the SanityTest debugging in the UI, the last sanity icon empties at 2
const MINIMUM_SANITY = 2

# Player Sanity Bars
const FULL_STRIKE = 24
const HALF_STRIKE = FULL_STRIKE / 2
const BUFFER_BETWEEN_SANITY_ICONS = 12

var eve_health_strikes = 0
var willow_health_strikes = 0

func _ready():
	# Start the players out with full health (assuming this will be at the very start of the game)
	# We currently have 3 sanity icons, so I guess full health = 3 sanity icons full
	eve_health_strikes = 3
	willow_health_strikes = 3

func find_inventory(starting_node):
	return find_node(starting_node, "UI/SharedInv/Inventory")

func find_slots_inventory_node(starting_node):
	return find_node(starting_node, "UI/SharedInv/Inv")

func find_player_one_sanity(starting_node):
	return find_node(starting_node, "UI/P1/P1Sanity")

func find_player_two_sanity(starting_node):
	return find_node(starting_node, "UI/P2/P2Sanity")

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
		decrease_sanity(eve_sanity_node, damage_in_strikes, eve_health_strikes)
	
	elif player_name == "Willow - P2":
		var willow_sanity_node = find_player_two_sanity(starting_node)
		decrease_sanity(willow_sanity_node, damage_in_strikes, willow_health_strikes)
	
	else:
		print("global_information.gd : deal_strike_damage_to_player() : player_name is not Eve - P1 or Willow - P2")

func decrease_sanity(sanity_node, damage_in_strikes, player_health_strikes):
	var damage = damage_in_strikes * FULL_STRIKE
	
	# If a player reaches 0 sanity
	if sanity_node.value - damage <= MINIMUM_SANITY:
		sanity_node.value = 0
		print("GAME OVER")
		return
	
	sanity_node.value -= damage
	
	var prev_strikes = player_health_strikes
	player_health_strikes -= damage_in_strikes
	
	# If the player's sanity dorps below a sanity icon, since there is a buffer between one...
	# ...sanity icon and another, move the sanity value past that buffer
	if ((prev_strikes / 1) - (player_health_strikes / 1) > 0):
		sanity_node.value -= BUFFER_BETWEEN_SANITY_ICONS
