extends VBoxContainer

var remaining_slots: int
var foods = ["eclair", "gingerbread", "yogurt", "cookie", "marshmallow", "donut", "popcorn", "cream"]
@export var solution = ["","","",""]
@export var curr = ["","","",""]
var rects = []
var positions = {}
signal empty_box(index)
signal puzzle_complete()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	foods.shuffle()
	remaining_slots = 4
	for i in remaining_slots:
		solution[i] = foods[i]
	for i in solution:
		print(i)
	for i in foods.size():
		var food = get_node("../" + foods[i])
		if food:
			positions[foods[i]] = food.global_position
	var resetB = get_node("../ResetButton")
	resetB.connect("button_object_emitted", reset)
	for lol in get_children():
		var rect = lol.get_node_or_null("ColorRect")
		if (rect):
			rects.append(rect)
		for p in lol.get_children():
			if p.has_signal("updated_guess"):
				p.updated_guess.connect(update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if remaining_slots == 0:
		check_if_correc(solution, curr)
	

func update(Box_Index, guess):
	curr[Box_Index] = guess
	update_remaining()
	for i in curr.size():
		print(curr[i])
	print("Rem: ", remaining_slots)
	if remaining_slots == 0:
		for i in curr.size():
			if curr[i] == solution[i]:
				rects[i].color = Color.GREEN
			elif curr[i] != solution[i]:
				if curr[i] in solution:
					rects[i].color = Color.YELLOW
					
			
					
func check_if_correc(solution, curr):
	for i in curr.size():
		if curr[i] != solution[i]:
			return false
	puzzle_complete.emit()
	return true
	
func reset(button):
	if remaining_slots == 0:
		for i in curr.size():
			if rects[i].color != Color.GREEN and rects[i].color != Color.YELLOW:
				print("Rect", i, " is removable, which has item ", curr[i],".")
				print("Searching for node: Panel", i,".")
				var searchPanel = "Panel" + str(i)
				remaining_slots += 1
				var text = get_node(searchPanel + "/TextureRect")
				if text:
					var rawName = curr[i]
					var respawnName = "res://scenes/" + rawName + ".tscn"
					text.visible = false
					curr[i] = ""
					if ResourceLoader.exists(respawnName):
						var reset_pos = load(respawnName).instantiate()
						reset_pos.z_index = -5
						reset_pos.global_position = positions[rawName]
						get_parent().add_child(reset_pos)
						empty_box.emit(i)	
# helper function ig
func not_green(index):
	return rects[index].color != Color.GREEN
		
func update_remaining():
	var count = 0
	for i in curr.size():
		if curr[i] == "":
			count += 1
	remaining_slots = count
						

			
