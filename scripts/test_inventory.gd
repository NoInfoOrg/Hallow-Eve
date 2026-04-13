extends Resource

class_name Inv
signal inv_updated 
@export var items: Array[Item]

func add_item(newItem: Item) -> bool:
	items.append(newItem)
	print("something happened btw")
	inv_updated.emit()
	return true
	
func remove_item(remItem: Item) -> bool:
	var index = 0
	for item in items:
		if item == remItem:
			items.remove_at(index)
			return true
		index += 1
	inv_updated.emit()
	return false


func get_inv_size() -> int:
	return items.size()
