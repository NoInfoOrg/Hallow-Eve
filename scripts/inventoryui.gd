extends Panel

@export var inventory: Node2D
@export var container: GridContainer
@export var slot: PackedScene

var slots = []

func _ready():
	inventory.connect("updated_inv", update)
	for i in range(6):
		var slotCell = slot.instantiate()
		container.add_child(slotCell)
		slots.append(slotCell)	
	update()
		
func update():
	for inv_slot in slots:
		var icon = inv_slot.get_node("Icon")
		icon.visible = false
		icon.texture = null
	for i in range(inventory.items.size()):
		if i < slots.size():
			var icon = slots[i].get_node("Icon")
			icon.custom_minimum_size = Vector2(50, 50)
			icon.visible = true
			var item = inventory.items[i]
			if item.texture:
				icon.texture = item.texture
			else:
				var loaded = load(item.resource_path)
				if loaded and loaded.texture:
					icon.texture = loaded.texture
					item.texture = loaded.texture
