@tool
extends Node2D

# AF - Sprite set up is based on MJ's code for loading enemy assets

enum RoomType {
	Bedroom,
	Bathroom,
	Kitchen,
	Freezer,
	Pantry,
	FamilyRoom,
	DiningRoom,
	Ballroom,
	Library,
	Study,
	Storage,
	SittingArea
}

enum BedroomAssetTypes{
	WallLampOff,
	WallLampOn,
	SleeplessChildBedComplete,
	SleeplessChildBedBack,
	SleeplessChildBedFront,
	SleeplessChildBedPoles,
	KidsArmchair,
	PlushiesLayingWhite,
	PlushiesLayingPurple,
	PlushiesLayingPink,
	PlushiesLayingBrown,
	PlushiesProppedWhite,
	PlushiesProppedPurple,
	PlushiesProppedPink,
	PlushiesProppedBrown,
	Homework,
	Nightstand,
	Bed,
	Mirror,
	Clock
}

enum BathroomAssetTypes {
	Sink,
	ToiletOpen,
	Closed,
	Shower,
	Tub
}

enum KitchenAssetTypes {
	CounterLong,
	CounterCornerPiece,
	CounterSide,
	Island,
	OvenStove,
	CounterNoCorner,
	CounterWithCorner
}

enum FreezerAssetTypes {
	Rack
}

enum PantryAssetTypes {
	Rack
}

enum FamilyRoomAssetTypes {
	CouchFront,
	CouchSide,
	TableBooks,
	TableEmpty
}

enum DiningRoomAssetTypes {
	ChairSide,
	ChairBack,
	ChairFront
}

enum BallroomAssetTypes {
	TableDecorations, 
	TableFlowers, 
	TableEmptyPlate, 
	TableFoodPlate,
	ChairFront,
	ChairSide
}

enum LibraryAssetTypes {
	TableBooks,
	TableBooksAndPaper,
	TableEmpty,
	TablePaper,
	BookcaseEmpty,
	BookcaseFull
}

enum StudyAssetTypes {
	Desk,
	CandleLampOff,
	CandleLampOn,
	ChairFrontPlastic,
	ChairFrontFelt,
	ChairSideFelt,
	ChairSideMuchroom,
	LampOrangeOff,
	LampOrangeOn,
	LampBlackOff,
	LampBlackOn
}

enum StorageAssetTypes {
	BrokenStatue2,
	BrokenStatue3,
	Picture1,
	Picture2,
	Picture3
}

enum SittingAreaAssetTypes {
	Loveseat,
	ArmchairFront,
	ArmchairSide
}

@export var roomType: RoomType:
	set(value):
		assetTroomTypeype = value
		assetIndex = 0
		setup_table()
		
		

var assetSprites = {
	AssetType.Decorations: preload("res://assets/sprites/environment/BallroomTable_Decorations.png"),
	AssetType.Flowers: preload("res://assets/sprites/environment/BallroomTable_Flowers.png"),
	AssetType.EmptyPlate: preload("res://assets/sprites/environment/BallroomTable_Plates-Empty.png"),
	AssetType.FoodPlate: preload("res://assets/sprites/environment/BallroomTable_Plates-Food.png")
}

func setup_table():
	if $Table != null:
		$Table.texture = assetSprites.get(assetType)
	else:
		return
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_table()
