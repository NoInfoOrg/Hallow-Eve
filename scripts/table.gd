@tool
extends Sprite2D

# AF - Sprite set up is based on MJ's code for loading enemy assets
enum TableType {Decorations, Flowers, EmptyPlate, FoodPlate}

var tableSprites = {
	TableType.Decorations: preload("res://assets/sprites/environment/BallroomTable_Decorations.png"),
	TableType.Flowers: preload("res://assets/sprites/environment/BallroomTable_Flowers.png"),
	TableType.EmptyPlate: preload("res://assets/sprites/environment/BallroomTable_Plates-Empty.png"),
	TableType.FoodPlate: preload("res://assets/sprites/environment/BallroomTable_Plates-Food.png")
}

func setup_table():
	if $Table != null:
		$Table.texture = tableSprites.get(TableType)
	else:
		return
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_table()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
