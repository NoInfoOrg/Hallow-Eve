extends GridContainer

var remaining_slots: int
@export var solution = ["R1C1","R1C2","R2C1","R2C2"]
@export var curr = ["","","",""]
var complete = false
var positions = {}
signal empty_box(index)
signal puzzle_complete()
@onready var token1 = get_node("../R1C1")
@onready var token2 = get_node("../R1C2")
@onready var token3 = get_node("../R2C1")
@onready var token4 = get_node("../R2C2")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var resetB = get_node("../ResetButton")
	resetB.connect("button_object_emitted", reset)
	for lol in get_children():
		for p in lol.get_children():
			if p.has_signal("updated_guess"):
				p.updated_guess.connect(update)
	#var token1 = get_node("../R1C1").global_position
	#var token2 = get_node("../R1C2").global_position
	#var token3 = get_node("../R2C1").global_position
	#var token4 = get_node("../R2C2").global_position
	positions["R1C1"] = Vector2i(148.0, 328.0)
	positions["R1C2"] = Vector2i(487.0, 264.0)
	positions["R2C1"] = Vector2i(311.0, 535.0)
	positions["R2C2"] = Vector2i(853.0, 534.0)
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if remaining_slots == 0:
		check_if_correc(solution, curr)
	
	

func update(Box_Index, guess):
	curr[Box_Index] = guess
	update_remaining()
	for i in curr.size():
		print("Curr at index ", i, ":",curr[i])
	print("Rem: ", remaining_slots)
					
			
					
func check_if_correc(solution, curr):
	for i in curr.size():
		if curr[i] != solution[i]:
			return false
	puzzle_complete.emit()
	complete = true
	return true
	
#func reset(button):
	#if remaining_slots == 0:
		#for i in curr.size():
			#if rects[i].color != Color.GREEN and rects[i].color != Color.YELLOW:
				#print("Rect", i, " is removable, which has item ", curr[i],".")
				#print("Searching for node: Panel", i,".")
				#var searchPanel = "Panel" + str(i)
				#remaining_slots += 1
				#var text = get_node(searchPanel + "/TextureRect")
				#if text:
					#var rawName = curr[i]
					#var respawnName = "res://scenes/" + rawName + ".tscn"
					#text.visible = false
					#curr[i] = ""
					#if ResourceLoader.exists(respawnName):
						#var reset_pos = load(respawnName).instantiate()
						#reset_pos.z_index = -5
						#reset_pos.global_position = positions[rawName]
						#get_parent().add_child(reset_pos)
						#empty_box.emit(i)	
## helper function ig
#func not_green(index):
	#return rects[index].color != Color.GREEN
		
func update_remaining():
	var count = 0
	for i in curr.size():
		if curr[i] == "":
			count += 1
	remaining_slots = count
						
func reset(button):
	if not complete and remaining_slots == 0:
		for i in curr.size():
			var searchPanel = "Panel" + str(i)
			print("searching for panel ", searchPanel)
			remaining_slots += 1
			var text = get_node(searchPanel + "/TextureRect")
			if text:
				var rawName = curr[i]
				print("Name: ", rawName)
				var box = get_node(searchPanel+ "/Area2D")
				box.hold_item = null
				box.full = false
				var respawnName = "res://scenes/" + rawName + ".tscn"
				print("Searching for scene...", respawnName)
				text.visible = false
				text = null
				curr[i] = ""
				if ResourceLoader.exists(respawnName):
					var reset_pos = load(respawnName).instantiate()
					reset_pos.z_index = -5
					reset_pos.global_position = positions[rawName]
					get_parent().add_child(reset_pos)
					
