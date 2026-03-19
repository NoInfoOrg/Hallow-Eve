extends Button

var inventory_shown = true
signal change_inventory_visibility(new_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_button_text()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	inventory_shown = !inventory_shown
	
	change_inventory_visibility.emit(inventory_shown)
	change_button_text()

func change_button_text():
	if inventory_shown:
		text = "Hide Inventory"
	elif not inventory_shown:
		text = "Show Inventory"
