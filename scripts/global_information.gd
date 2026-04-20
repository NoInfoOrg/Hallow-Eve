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

# Game volumes
const MINIMUM_LINEAR_VOLUME = 0.0
const MAXIMUM_LINEAR_VOLUME = 1.0

var current_master_volume_linear = 1.0
var current_music_volume_linear = 1.0

# Setting State
var is_in_main_menu: bool = true  # Assuming we start in the main menu

# level change
enum scenes { MAIN_MENU, LEVEL_1, LEVEL_2, LEVEL_3 }
var current_scene = "main_menu"
var transition_scene = false

var music_scene = scenes.MAIN_MENU
var music_scene_duplicate_check = music_scene

var saved_scene = scenes.LEVEL_1

var player_exit_level_1_posx = 0
var player_exit_level_1_posy = 0
var player_start_posx = 0
var player_start_posy = 0

func _ready():
	# Start the players out with full health (assuming this will be at the very start of the game)
	# We currently have 3 sanity icons, so I guess full health = 3 sanity icons full
	eve_health_strikes = MAX_PLAYER_HEALTH_STRIKES
	willow_health_strikes = MAX_PLAYER_HEALTH_STRIKES
	
	# Start the game with max volume
	current_master_volume_linear = 1.0
	current_music_volume_linear = 1.0
	
	# Start playing music!
	#change_music()
#
#func _process(float) -> void:
	#if music_scene != music_scene_duplicate_check:
		#change_music()
		#music_scene_duplicate_check = music_scene

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

func find_music_node(starting_node):
	return starting_node.get_tree().root.find_child("Music", true, false)

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
		
		# Default cases that signify that the inventory is not found
		if current_node == root or current_node == null:
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
		var EveHealth = get_tree().current_scene.find_child("EveOuch", true, false)
		EveHealth.play()
		#print("NEW EVE BUFFER HEALTH IS: ")
		#print(eve_health_strikes)
	
	elif player_name == "Willow - P2":
		var willow_sanity_node = find_player_two_sanity(starting_node)
		var WillowHit = get_tree().current_scene.find_child("WillowOuch", true, false)
		willow_health_strikes = decrease_sanity(willow_sanity_node, damage_in_strikes, willow_health_strikes)
		WillowHit.play()
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

## Game volumes
#const MINIMUM_LINEAR_VOLUME = 0.0
#const MAXIMUM_LINEAR_VOLUME = 1.0
#
#var current_master_volume_linear = 1.0
#var current_music_volume_linear = 1.0

func increase_volume(volume_to_increase: String) -> void:
	# Lizz so far has drawn 10 textures for the volume settings, so 1.0 / 10 = 0.1
	const INCREASE_AMOUNT = 0.1
	
	if volume_to_increase == "Master Volume":
		if current_master_volume_linear + INCREASE_AMOUNT > MAXIMUM_LINEAR_VOLUME:
			return
		
		current_master_volume_linear += INCREASE_AMOUNT
		reduce_volumes(get_tree().root)
		return
		
	elif volume_to_increase == "Music Volume":
		if current_music_volume_linear + INCREASE_AMOUNT > MAXIMUM_LINEAR_VOLUME:
			return
		
		current_music_volume_linear += INCREASE_AMOUNT
		reduce_volumes(get_tree().root)
		return
		
	else:
		return

func decrease_volume(volume_to_decrease: String) -> void:
	# Lizz so far has drawn 10 textures for the volume settings, so 1.0 / 10 = 0.1
	const DECREASE_AMOUNT = 0.1
	
	if volume_to_decrease == "Master Volume":
		if current_master_volume_linear - DECREASE_AMOUNT < MINIMUM_LINEAR_VOLUME:
			return
		
		current_master_volume_linear -= DECREASE_AMOUNT
		reduce_volumes(get_tree().root)
		return
		
	elif volume_to_decrease == "Music Volume":
		if current_music_volume_linear - DECREASE_AMOUNT < MINIMUM_LINEAR_VOLUME:
			return
		
		current_music_volume_linear -= DECREASE_AMOUNT
		reduce_volumes(get_tree().root)
		return
		
	else:
		return

func increase_master_volume() -> void:
	increase_volume("Master Volume")

func increase_music_volume() -> void:
	increase_volume("Music Volume")

func decrease_master_volume() -> void:
	decrease_volume("Master Volume")

func decrease_music_volume() -> void:
	decrease_volume("Music Volume")

func reduce_volumes(starting_node):
	for child_node in starting_node.get_children():
		if child_node is AudioStreamPlayer:
			if child_node.is_in_group("Music"):
				child_node.set_volume_linear(current_master_volume_linear * current_music_volume_linear)
			
			else:
				child_node.set_volume_linear(current_master_volume_linear)
		
		reduce_volumes(child_node)

func complete_change_scenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "main_menu":
			current_scene = "level_1_scene"
			music_scene = scenes.LEVEL_1
		elif current_scene == "level_1_scene":
			current_scene = "level_2_scene"
			music_scene = scenes.LEVEL_2
		elif current_scene == "level_2_scene":
			current_scene = "level_3_scene"
			music_scene = scenes.LEVEL_3
		else:
			current_scene = "level_1_scene"
			music_scene = scenes.LEVEL_1

#func change_music():
	#var main_menu_theme = Music.get_node("Ambient Music/Main Music Halloween Theme")
	#var level_1_theme = Music.get_node("Ambient Music/Level 1 Ambience")
	#var level_2_theme = Music.get_node("Ambient Music/Level 2 Library")
	#var level_3_theme = Music.get_node("Ambient Music/Level 3 Ballroom")
	
	# Stop all background music that was previously playing
	#main_menu_theme.stop()
	#level_1_theme.stop()
	#level_2_theme.stop()
	#level_3_theme.stop()
	
	#if music_scene == scenes.MAIN_MENU:
		#main_menu_theme.play()
	#
	#elif music_scene == scenes.LEVEL_1:
		#level_1_theme.play()
	#
	#elif music_scene == scenes.LEVEL_2:
		#level_2_theme.play()
	#
	#elif music_scene == scenes.LEVEL_3:
		#level_3_theme.play()
	
	#else:
		#print("change_music() : invalid music scene")

func advance_level():
	# TODO: Using the music_scene might not be the best maybe?
	if music_scene == scenes.LEVEL_1:
		get_tree().change_scene_to_file("res://scenes/level_2_scene.tscn")
	
	elif music_scene == scenes.LEVEL_2:
		get_tree().change_scene_to_file("res://scenes/level_3_scene.tscn")
	
	elif music_scene == scenes.LEVEL_3:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
