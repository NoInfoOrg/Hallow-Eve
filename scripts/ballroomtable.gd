extends Node2D

# AF - Sprite set up is based on MJ's code for loading enemy assets

@export var tableType: TableType:
	set(value):
		tableType = value
		setup_table()
		
		
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
