extends Node2D

signal updated_inv
@export var items: Array[Item]

func add_item(newItem: Item) -> bool:
	items.append(newItem)
	updated_inv.emit()
	print("you got: ")
	var count = 1
	for item in items:
		print(count, ": ", item.name)
		count += 1
	return true
	
func remove_item(remItem: Item) -> bool:
	var index = 0
	for item in items:
		if item == remItem:
			items.remove_at(index)
			updated_inv.emit()
			return true
		index += 1
	updated_inv.emit()
	return false


func get_inv_size() -> int:
	return items.size()
