@tool
extends Node2D

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

const roomEnums = {
	RoomType.Bedroom: BedroomAssetTypes,
	RoomType.Bathroom: BathroomAssetTypes,
	RoomType.Kitchen: KitchenAssetTypes,
	RoomType.Freezer: FreezerAssetTypes,
	RoomType.Pantry: PantryAssetTypes,
	RoomType.FamilyRoom: FamilyRoomAssetTypes,
	RoomType.DiningRoom: DiningRoomAssetTypes,
	RoomType.Ballroom: BallroomAssetTypes,
	RoomType.Library: LibraryAssetTypes,
	RoomType.Study: StudyAssetTypes,
	RoomType.Storage: StorageAssetTypes,
	RoomType.SittingArea: SittingAreaAssetTypes
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
	TableDecorationsComplete,
	TableFlowersComplete,
	TableEmptyPlateComplete,
	TableFoodPlateComplete,
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
		roomType = value
		assetIndex = 0
		clear_children()
		spawn_current_asset()
		if Engine.is_editor_hint():
			notify_property_list_changed()
		
@export var assetIndex: int = 0:
	set(value):
		assetIndex = value
		clear_children()
		spawn_current_asset()

const assetScenes = {
	RoomType.Bedroom: {
		BedroomAssetTypes.WallLampOff: preload("res://scenes/wall_lamp_off.tscn"),
		BedroomAssetTypes.WallLampOn: preload("res://scenes/wall_lamp_on.tscn"),
		BedroomAssetTypes.SleeplessChildBedComplete: preload("res://scenes/sleepless_child_bed_complete.tscn"),
		#BedroomAssetTypes.SleeplessChildBedBack: preload(),
		#BedroomAssetTypes.SleeplessChildBedFront: preload(),
		#BedroomAssetTypes.SleeplessChildBedPoles: preload(),
		BedroomAssetTypes.KidsArmchair: preload("res://scenes/kids_armchair.tscn"),
		BedroomAssetTypes.PlushiesLayingWhite: preload("res://scenes/plushie_laying_white.tscn"),
		BedroomAssetTypes.PlushiesLayingPurple: preload("res://scenes/plushie_laying_purple.tscn"),
		BedroomAssetTypes.PlushiesLayingPink: preload("res://scenes/plushie_laying_pink.tscn"),
		BedroomAssetTypes.PlushiesLayingBrown: preload("res://scenes/plushie_laying_brown.tscn"),
		BedroomAssetTypes.PlushiesProppedWhite: preload("res://scenes/plushie_propped_white.tscn"),
		BedroomAssetTypes.PlushiesProppedPurple: preload("res://scenes/plushie_propped_purple.tscn"),
		BedroomAssetTypes.PlushiesProppedPink: preload("res://scenes/plushie_propped_pink.tscn"),
		BedroomAssetTypes.PlushiesProppedBrown: preload("res://scenes/plushie_propped_brown.tscn"),
		BedroomAssetTypes.Homework: preload("res://scenes/homework.tscn"),
		BedroomAssetTypes.Nightstand: preload("res://scenes/nightstand.tscn"),
		BedroomAssetTypes.Bed: preload("res://scenes/bed.tscn"),
		BedroomAssetTypes.Mirror: preload("res://scenes/mirror.tscn"),
		BedroomAssetTypes.Clock: preload("res://scenes/clock.tscn"),
	},
	RoomType.Bathroom: {
		BathroomAssetTypes.Sink: preload("res://scenes/sink.tscn"),
		BathroomAssetTypes.ToiletOpen: preload("res://scenes/toilet_open.tscn"),
		BathroomAssetTypes.Closed: preload("res://scenes/toilet_closed.tscn"),
		BathroomAssetTypes.Shower: preload("res://scenes/shower.tscn"),
		BathroomAssetTypes.Tub: preload("res://scenes/tub.tscn"),
	},
	RoomType.Kitchen: {
		KitchenAssetTypes.CounterLong: preload("res://scenes/counter_long.tscn"),
		KitchenAssetTypes.CounterCornerPiece: preload("res://scenes/counter_corner_piece.tscn"),
		KitchenAssetTypes.CounterSide: preload("res://scenes/counter_side.tscn"),
		KitchenAssetTypes.Island: preload("res://scenes/island.tscn"),
		KitchenAssetTypes.OvenStove: preload("res://scenes/oven_stove.tscn"),
		KitchenAssetTypes.CounterNoCorner: preload("res://scenes/counter_no_corner.tscn"),
		KitchenAssetTypes.CounterWithCorner: preload("res://scenes/counter_with_corner.tscn"),
	},
	RoomType.Freezer: {
		FreezerAssetTypes.Rack: preload("res://scenes/freezer_rack.tscn"),
	},
	#RoomType.Pantry: {
		#PantryAssetTypes.Rack: preload(),
	#},
	#RoomType.FamilyRoom: {
		#FamilyRoomAssetTypes.CouchFront: preload(),
		#FamilyRoomAssetTypes.CouchSide: preload(),
		#FamilyRoomAssetTypes.TableBooks: preload(),
		#FamilyRoomAssetTypes.TableEmpty: preload(),
	#},
	#RoomType.DiningRoom: {
		#DiningRoomAssetTypes.ChairSide: preload(),
		#DiningRoomAssetTypes.ChairBack: preload(),
		#DiningRoomAssetTypes.ChairFront: preload(),
	#},
	RoomType.Ballroom: {
		BallroomAssetTypes.TableDecorationsComplete: preload("res://scenes/ballroom_table_decorations_complete.tscn"),
		BallroomAssetTypes.TableFlowersComplete: preload("res://scenes/ballroom_table_flowers_complete.tscn"),
		BallroomAssetTypes.TableEmptyPlateComplete: preload("res://scenes/ballroom_table_empty_complete.tscn"),
		BallroomAssetTypes.TableFoodPlateComplete: preload("res://scenes/ballroom_table_food_complete.tscn"),
	},
	#RoomType.Library: {
		#LibraryAssetTypes.TableBooks: preload(),
		#LibraryAssetTypes.TableBooksAndPaper: preload(),
		#
	#},
	#RoomType.Study: {
		#
	#},
	#RoomType.Storage: {
		#
	#},
	#RoomType.SittingArea: {
		#
	#}
}

	
func spawn_asset(assetType: int) -> void:
	if !assetScenes.has(roomType):
		return
	if !assetScenes[roomType].has(assetType):
		return
	var scene = assetScenes[roomType][assetType]
	var instance = scene.instantiate()
	add_child(instance)
	
func spawn_current_asset():
	if !assetScenes.has(roomType):
		return
	var keys = assetScenes[roomType].keys()
	if assetIndex >= 0 and assetIndex < keys.size():
		spawn_asset(keys[assetIndex])
	
func _get_property_list():
	var properties = []
	var enum_string = ""
	if roomEnums.has(roomType):
		enum_string = ",".join(roomEnums[roomType].keys())
	properties.append({
		"name": "assetIndex",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": enum_string
	})
	return properties

func _set(property, value):
	if property == "assetIndex":
		assetIndex = value
		
		if Engine.is_editor_hint():
			clear_children()
			
			if assetScenes.has(roomType):
				var keys = assetScenes[roomType].keys()
				
				if assetIndex >= 0 and assetIndex < keys.size():
					spawn_asset(keys[assetIndex])
		return true
	return false

func clear_children():
	for child in get_children():
		child.queue_free()
