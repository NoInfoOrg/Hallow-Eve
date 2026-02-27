extends Panel

@onready var item_vis: Sprite2D = $testItem

func update(item: Item):
	if !item:
		item_vis.visible = false
	else:
		item_vis.visible = true
		item_vis.texture = item.texture
