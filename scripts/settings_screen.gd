extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GlobalInformation.is_in_main_menu:
		get_node("Control/Panel/VBoxContainer/Toggle Inventory").hide()
