extends CharacterBody2D
class_name Player

@onready var ui = get_tree().get_first_node_in_group("UI")
var enemy_count = 0

# Constants
const SPEED = 300.0
const PUSH_FORCE = 150.0

# Can be changed between instances
var move_left_action = null
var move_right_action = null
var move_up_action = null
var move_down_action = null
var grab_left_action = null
var grab_right_action = null
var open = null
var idle_left = null
var idle_right = null
var idle_up = null
var idle_down = null
var walk_left = null
var walk_right = null
var walk_up = null
var walk_down = null
var take_damage = null
var push_left = null
var push_right = null

# INFO: Assuming that the player starts out facing to the front
var lastDirection : String = "S"

# INFO Sources:
# https://forum.godotengine.org/t/how-to-properly-change-the-sprite-depending-on-facing-direction-and-other-situations/19024
# https://forum.godotengine.org/t/how-do-i-change-sprite-texture-in-gdscript/51473
	
		
func _physics_process(delta):
	var direction = Input.get_vector(move_left_action, move_right_action, move_up_action, move_down_action)
	velocity = direction * SPEED
	
	move_and_slide()
	
	## INFO grab_action allows to open doors and press buttons
	if Input.is_action_just_pressed(open):
		check_to_open_door()
	
	# INFO The Player's Walking Animations (uses idle for placeholder)
	var moving_left = Input.is_action_pressed(move_left_action)
	var moving_right = Input.is_action_pressed(move_right_action)
	var moving_up = Input.is_action_pressed(move_up_action)
	var moving_down = Input.is_action_pressed(move_down_action)
	
	if moving_left and not (moving_up or moving_down):
		$AnimationPlayer.play(walk_left)
		lastDirection = "A"
		check_box_collision(-PUSH_FORCE, 0, delta)
		
	elif moving_right and not (moving_up or moving_down):
		$AnimationPlayer.play(walk_right)
		lastDirection = "D"
		check_box_collision(PUSH_FORCE, 0, delta)
		
	elif moving_up and not (moving_left or moving_right):
		$AnimationPlayer.play(walk_up)
		lastDirection = "W"
		check_box_collision(0, -PUSH_FORCE, delta)
		
	elif moving_down and not (moving_left or moving_right):
		$AnimationPlayer.play(walk_down)
		lastDirection = "S"
		check_box_collision(0, PUSH_FORCE, delta)
	
	# INFO meant to return animation to idle, but [DESTROYS] the debugger - Lizz
	# INFO I think this fixes it? But I don't know if this is what you had in mind - Nick
	elif velocity == Vector2.ZERO:
		if lastDirection == "W":
			$AnimationPlayer.play(idle_up)
		elif lastDirection == "A":
			$AnimationPlayer.play(idle_left)
		elif lastDirection == "S":
			$AnimationPlayer.play(idle_down)
		elif lastDirection == "D":
			$AnimationPlayer.play(idle_right)

func check_box_collision(x_push, y_push, delta):
	for i in get_slide_collision_count():
		# Make sure the player is actually moving in the direction they are pushing
		if y_push != 0 and (lastDirection == "A" or lastDirection == "D"):
			return
		elif x_push != 0 and (lastDirection == "W" or lastDirection == "S"):
			return
		
		var collision = get_slide_collision(i)
		var collision_box = collision.get_collider()
		
		# Make sure that the player is actually moving in the direction they are pushing
		var normal = collision.get_normal()
		#print(normal)
		
		const LEFT_DIRECTION = Vector2(-1.0, 0.0)
		const RIGHT_DIRECTION = Vector2(1.0, 0.0)
		const UP_DIRECTION = Vector2(0.0, -1.0)
		const DOWN_DIRECTION = Vector2(0.0, 1.0)
		
		if x_push != 0 and (normal == UP_DIRECTION or normal == DOWN_DIRECTION):
			return
		elif x_push > 0 and normal == RIGHT_DIRECTION:
			return
		elif x_push < 0 and normal == LEFT_DIRECTION:
			return
		elif y_push != 0 and (normal == LEFT_DIRECTION or normal == RIGHT_DIRECTION):
			return
		elif y_push > 0 and normal == DOWN_DIRECTION:
			return
		elif y_push < 0 and normal == UP_DIRECTION:
			return
		
		# At this point, it should ideally be confirmed that the player is moving to push the box
		if collision_box.is_in_group("Boxes") or collision_box.is_in_group("Spirit Boxes"):
			collision_box.push_by_player(Vector2(delta * x_push, delta * y_push), PUSH_FORCE)

func check_to_open_door():
	# Find the inventory first
	var inventory = GlobalInformation.find_inventory(self)
	if inventory == null:
		print("danger type beat")
		print("inventory not found")
		return
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var door = collision.get_collider()
		var door_verify = false
		
		if not door.is_in_group("Doors"):
			return
		
		var index = 0
		for item in inventory.items:
			print(item.name)
			
			if item.name == door.required_key_name:
				print("key :D")
				door_verify = true
				
				# Remove the item from the inventory (this is experimental)
				var slots_node = GlobalInformation.find_slots_inventory_node(self)
				if slots_node == null:
					print("inventory slot not found")
					return
					
				var removed_inventory_icon = slots_node.slots[index].get_node("Icon")
				
				removed_inventory_icon.visible = false
				removed_inventory_icon.texture = null
				inventory.items.remove_at(index)
			
			index += 1
				
		if door.is_in_group("Doors") and door_verify:
			# Only open doors that are not button-operated
			if door.synced_buttons_needed:
				return
			
			# Change the door image to be opened
			# door.get_node("Door").play("open")
			if door.has_node("OpenDoor"):
				door.get_node("OpenDoor").visible = true
			
			if door.has_node("ClosedDoor"):
				door.get_node("ClosedDoor").visible = false
			
			# Change the door collision so players can enter the door
			door.get_node("Closed Door Collision").set_deferred("disabled", true)

func _on_hit_box_zone_body_entered(body: Node2D) -> void:
	pass # Replace with function body.

func _on_hit_box_zone_body_exited(body: Node2D) -> void:
	pass # Replace with function body.

func _on_enemy_detection_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy Detection Zone"):
		enemy_count += 1
		if ui:
			ui.show_ui()
			ui.hide_timer.stop()

func _on_enemy_detection_zone_area_exited(area: Area2D) -> void:
	if area.is_in_group("Enemy Detection Zone"):
		enemy_count -= 1
		if enemy_count <= 0:
			enemy_count = 0
			if ui:
				check_player_safety()
				
func check_player_safety():
	if not ui:
		return
	
	var players = get_tree().get_nodes_in_group("Players")
	var in_danger = false
	var low_health = GlobalInformation.eve_health_strikes <= 1 or GlobalInformation.willow_health_strikes <= 1
	
	for player in players:
		if player.enemy_count > 0:
			in_danger = true
			break
	if in_danger or low_health:
		ui.show_ui()
		ui.hide_timer.stop()
	else:
		ui.hide_timer.start()

func current_camera():
	if GlobalInformation.current_scene == "level_1_scene":
		pass
	elif GlobalInformation.current_scene == "level_2_scene":
		pass
	elif GlobalInformation.current_scene == "level_3_scene":
		pass
	else:
		pass
