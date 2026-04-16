extends BaseButton

var settings_unpressed = preload("res://assets/ui elements/settings/Settings_MainMenuButton.png")
var settings_pressed = preload("res://assets/ui elements/settings/Settings_MainMenuButton-Pressed.png")

var settings_open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var settings_screen = get_node("Settings Screen")
	var back_to_menu_button = settings_screen.get_node("Control/Panel/VBoxContainer/Back to Menu")
	var inventory_toggle_button = settings_screen.get_node("Control/Panel/VBoxContainer/Toggle Inventory")
	
	settings_screen.hide()
	back_to_menu_button.connect("back_to_menu", _on_pressed)
	inventory_toggle_button.connect("change_inventory_visibility", on_change_inventory_visibility)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	settings_open = !settings_open
	
	var menu = get_node("../../../")
	var settings = get_node("Settings Screen")
	
	if settings_open:
		settings.show()
		menu.hide()
	elif not settings_open:
		settings.hide()
		menu.show()

func on_change_inventory_visibility(new_inventory_state):
	var inventory = get_node("../../../../../SharedInv")
	
	if new_inventory_state == true:
		inventory.show()
	elif new_inventory_state == false:
		inventory.hide()
