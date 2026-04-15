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
	SittingArea,
	Windows,
	OtherWallDecor
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
	RoomType.SittingArea: SittingAreaAssetTypes,
	RoomType.Windows: WindowAssetTypes,
	RoomType.OtherWallDecor: OtherWallDecorTypes
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
	Clock,
	PlushiesGroup,
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
	ChairSideMushroom,
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

enum WindowAssetTypes {
	Morning,
	Noon,
	Evening,
	Night,
	Frame
}

enum OtherWallDecorTypes {
	CobwebCenter,
	CobwebCorner,
	CobwebMiddle,
	CobwebSide
}

@export var roomType: RoomType:
	set(value):
		roomType = value
		if Engine.is_editor_hint():
			asset = BedroomAssetTypes.WallLampOff
			place_asset()
			notify_property_list_changed()

var asset:
	set(value):
		asset = value
		place_asset()

const assetScenes = {
	RoomType.Bedroom: {
		BedroomAssetTypes.WallLampOff: preload("res://scenes/wall_lamp_off.tscn"),
		BedroomAssetTypes.WallLampOn: preload("res://scenes/wall_lamp_on.tscn"),
		BedroomAssetTypes.SleeplessChildBedComplete: preload("res://scenes/sleepless_child_bed_complete.tscn"),
		BedroomAssetTypes.SleeplessChildBedBack: preload("res://scenes/sleepless_child_bed_poles.tscn"),
		BedroomAssetTypes.SleeplessChildBedFront: preload("res://scenes/sleepless_child_bed_front.tscn"),
		BedroomAssetTypes.SleeplessChildBedPoles: preload("res://scenes/sleepless_child_bed_back.tscn"),
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
		BedroomAssetTypes.PlushiesGroup: preload("res://scenes/plushiegroup.tscn"),
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
	RoomType.Pantry: {
		PantryAssetTypes.Rack: preload("res://scenes/pantry_rack.tscn"),
	},
	RoomType.FamilyRoom: {
		FamilyRoomAssetTypes.CouchFront: preload("res://scenes/couch_front.tscn"),
		FamilyRoomAssetTypes.CouchSide: preload("res://scenes/couch_side.tscn"),
		FamilyRoomAssetTypes.TableBooks: preload("res://scenes/table_books.tscn"),
		FamilyRoomAssetTypes.TableEmpty: preload("res://scenes/table_empty.tscn"),
	},
	RoomType.DiningRoom: {
		DiningRoomAssetTypes.ChairSide: preload("res://scenes/chair_side.tscn"),
		DiningRoomAssetTypes.ChairBack: preload("res://scenes/chair_back.tscn"),
		DiningRoomAssetTypes.ChairFront: preload("res://scenes/chair_front.tscn"),
	},
	RoomType.Ballroom: {
		BallroomAssetTypes.TableDecorationsComplete: preload("res://scenes/ballroom_table_decorations_complete.tscn"),
		BallroomAssetTypes.TableFlowersComplete: preload("res://scenes/ballroom_table_flowers_complete.tscn"),
		BallroomAssetTypes.TableEmptyPlateComplete: preload("res://scenes/ballroom_table_empty_complete.tscn"),
		BallroomAssetTypes.TableFoodPlateComplete: preload("res://scenes/ballroom_table_food_complete.tscn"),
	},
	RoomType.Library: {
		LibraryAssetTypes.TableBooks: preload("res://scenes/lib_table_books.tscn"),
		LibraryAssetTypes.TableBooksAndPaper: preload("res://scenes/lib_table_books_and_paper.tscn"),
		LibraryAssetTypes.TableEmpty: preload("res://scenes/lib_table_empty.tscn"),
		LibraryAssetTypes.TablePaper: preload("res://scenes/lib_table_paper.tscn"),
		LibraryAssetTypes.BookcaseEmpty: preload("res://scenes/lib_bookcase_empty.tscn"),
		LibraryAssetTypes.BookcaseFull: preload("res://scenes/lib_bookcase_full.tscn"),
	},
	RoomType.Study: {
		StudyAssetTypes.Desk: preload("res://scenes/desk.tscn"),
		StudyAssetTypes.CandleLampOff: preload("res://scenes/candle_lamp_off.tscn"),
		StudyAssetTypes.CandleLampOn: preload("res://scenes/candle_lamp_on.tscn"),
		StudyAssetTypes.ChairFrontPlastic: preload("res://scenes/chair_front_plastic.tscn"),
		StudyAssetTypes.ChairFrontFelt: preload("res://scenes/chair_front_felt.tscn"),
		StudyAssetTypes.ChairSideFelt: preload("res://scenes/chair_side_felt.tscn"),
		StudyAssetTypes.ChairSideMushroom: preload("res://scenes/chair_side_mushroom.tscn"),
		StudyAssetTypes.LampOrangeOff: preload("res://scenes/lamp_orange_off.tscn"),
		StudyAssetTypes.LampOrangeOn: preload("res://scenes/lamp_orange_on.tscn"),
		StudyAssetTypes.LampBlackOff: preload("res://scenes/lamp_black_off.tscn"),
		StudyAssetTypes.LampBlackOn: preload("res://scenes/lamp_black_on.tscn"),
	},
	RoomType.Storage: {
		StorageAssetTypes.BrokenStatue2: preload("res://scenes/broken_statue2.tscn"),
		StorageAssetTypes.BrokenStatue3: preload("res://scenes/broken_statue3.tscn"),
		StorageAssetTypes.Picture1: preload("res://scenes/picture1.tscn"),
		StorageAssetTypes.Picture2: preload("res://scenes/picture2.tscn"),
		StorageAssetTypes.Picture3: preload("res://scenes/picture3.tscn"),
	},
	RoomType.SittingArea: {
		SittingAreaAssetTypes.Loveseat: preload("res://scenes/loveseat.tscn"),
		SittingAreaAssetTypes.ArmchairFront: preload("res://scenes/armchair_front.tscn"),
		SittingAreaAssetTypes.ArmchairSide: preload("res://scenes/armchair_side.tscn"),
	},
	RoomType.Windows: {
		WindowAssetTypes.Morning: preload("res://scenes/window_morning.tscn"),
		WindowAssetTypes.Noon: preload("res://scenes/window_noon.tscn"),
		WindowAssetTypes.Evening: preload("res://scenes/window_evening.tscn"),
		WindowAssetTypes.Night: preload("res://scenes/window_night.tscn"),
		WindowAssetTypes.Frame: preload("res://scenes/window_frame.tscn"),
	},
	RoomType.OtherWallDecor: {
		OtherWallDecorTypes.CobwebCenter: preload("res://scenes/cobweb_center.tscn"),
		OtherWallDecorTypes.CobwebCorner: preload("res://scenes/cobweb_corner.tscn"),
		OtherWallDecorTypes.CobwebMiddle: preload("res://scenes/cobweb_middle.tscn"),
		OtherWallDecorTypes.CobwebSide: preload("res://scenes/cobweb_side.tscn"),
	},
}

func place_asset():
	clear_children()
	if !assetScenes.has(roomType) or !assetScenes[roomType].has(asset):
		return
	else:
		var scene = assetScenes[roomType][asset]
		var instance = scene.instantiate()
		var assetName = roomEnums[roomType].keys()[asset]
		self.name = assetName
		add_child(instance)

func _get_property_list():
	var properties = []
	var enumString = ""
	if roomEnums.has(roomType):
		enumString = ",".join(roomEnums[roomType].keys())
	properties.append({
		"name": "asset",
		"type": TYPE_INT,
		"usage": PROPERTY_USAGE_EDITOR | PROPERTY_USAGE_STORAGE,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": enumString
	})
	return properties

func _set(property, value):
	if property == "asset":
		if Engine.is_editor_hint():
			clear_children()
			if assetScenes.has(roomType):
				var keys = assetScenes[roomType].keys()
				if value >= 0:
					if value < keys.size():
						asset = keys[value]
						place_asset()
		return true
	return false

func clear_children():
	for child in get_children():
		child.queue_free()
