extends LineEdit


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton:
		if clicked_outside_answer_box(event.position):
			release_focus()

func clicked_outside_answer_box(mouse_position: Vector2):
	var answer_box_position = get_global_rect()
	
	var leftmost_x = answer_box_position.position.x
	var rightmost_x = answer_box_position.end.x
	
	var leftmost_y = answer_box_position.position.y
	var rightmost_y = answer_box_position.end.y
	
	var in_x_bounds = (mouse_position.x >= leftmost_x) and (mouse_position.x <= rightmost_x)
	var in_y_bounds = (mouse_position.y >= leftmost_y) and (mouse_position.y <= rightmost_y)
	
	# If we clicked in the answer box, then we did not click outside of it
	if in_x_bounds and in_y_bounds:
		return false
	else:
		return true
