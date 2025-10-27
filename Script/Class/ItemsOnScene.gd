extends Node

@export var player: Player
const PICK_UP_DISTANCE: float = 40

@export var item_area: Dictionary[String, ItemArea]
var items_in_scen: Dictionary[Item, Area2D]

var player_pick_up_item: bool = false
var pointing_on: State.Cursors_above = State.Cursors_above.NONE

var steel_sheet: Item = Item.new(
	"Steel sheet", 
	[], 
	true, 
	"res://Sprite/Items/SteelSheetSmal.png", 
	"res://Sprite/Items/SteelSheet.png", 
	[],
	"",  
	"",    
	"",    
	[],    
	true 
)

var crystal_shard: Item = Item.new(
	"Crystal shard", 
	[], 
	true, 
	"res://Sprite/Items/CrystalShardSmall.png", 
	"res://Sprite/Items/CrystalShard.png", 
	[],
	"",
	"",
	"",
	[],
	true 
)

func _ready() -> void:
	_add_items("steel_sheet", steel_sheet)
	_add_items("crystal_shard", crystal_shard)

	Signals.mouse_off_item.connect(_on_mouse_off_item)
	Signals.mouse_above_item.connect(_above_item)

	_remove_already_pickup_item()


func _on_mouse_off_item() -> void:
	pointing_on = State.Cursors_above.NONE
	player_pick_up_item = false


func _add_items(item_name: String, _item: Item) -> void:
	if item_name in item_area:
		items_in_scen[_item] = item_area[item_name]


func _remove_already_pickup_item() -> void:
	var items_to_remove := []
	for item in items_in_scen:
		for picked_item in State.pick_up_items:
			if picked_item.item_name == item.item_name:
				items_to_remove.append(item)
				break

	for item in items_to_remove:
		var item_type = _get_item_type(item)
		if item_type != State.Cursors_above.NONE:
			Signals.remove_items_from_scene.emit(item_type)
		items_in_scen.erase(item)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("MovePlayer") and player_pick_up_item:
		player_pick_up_item = false

		if State.player_in_item_area:
			match pointing_on:
				State.Cursors_above.STEEL_SHEET:
					_pick_up(steel_sheet)
				State.Cursors_above.CRYSTAL_SHARD:
					_pick_up(crystal_shard)
		else:
			pointing_on = State.Cursors_above.NONE


func _pick_up(_item: Item) -> void:
	_item.add_to_equipment()
	pointing_on = State.Cursors_above.NONE

	var item_type = _get_item_type(_item)
	if item_type != State.Cursors_above.NONE:
		Signals.remove_items_from_scene.emit(item_type)

	if items_in_scen.has(_item):
		items_in_scen.erase(_item)


func _above_item(area: State.Cursors_above) -> void:
	pointing_on = area
	player_pick_up_item = true


# Pomocnicza funkcja do mapowania przedmiotu na typ enum
func _get_item_type(item: Item) -> State.Cursors_above:
	if item == steel_sheet:
		return State.Cursors_above.STEEL_SHEET
	elif item == crystal_shard:
		return State.Cursors_above.CRYSTAL_SHARD
	else:
		return State.Cursors_above.NONE
