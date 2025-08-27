extends Node

@export var player: Player
const PICK_UP_DISTANCE: float = 40

@export var item_area: Dictionary[String,Area2D]
var items_in_scen: Dictionary[Item, Area2D]

enum Cursors_above{
	STEEL_SHEET,
	CRYSTAL_SHARD,
	NONE
}
var pointing_on: Cursors_above = Cursors_above.NONE

var item_position: Vector2

var steel_sheet: Item = Item.new("Steel sheet",[],true,"res://Sprite/Items/SteelSheetSmal.png","res://Sprite/Items/SteelSheet.png",[])
var crystal_shard: Item = Item.new("Crystal shard",[],true,"res://Sprite/Items/CrystalShardSmall.png","res://Sprite/Items/CrystalShard.png",[])

func _distance_to_item() -> bool:
	if player.global_position.distance_to(item_position) <= PICK_UP_DISTANCE:
		return true
	return false

func _ready() -> void:
	_add_items("steel_sheet", steel_sheet)
	_add_items("crystal_shard", crystal_shard)
	
	Signals.mouse_off_item.connect(func ():
		pointing_on = Cursors_above.NONE
		)
	
	Signals.mouse_above_item.connect(_above_item)
	
	_remove_already_pickup_item()

func _add_items(item_name: String, _item: Item) -> void:
	if item_name in item_area:
		items_in_scen[_item] =  item_area[item_name]

func _remove_already_pickup_item() -> void:
	var items_to_remove := []
	# Sprawdź każdy przedmiot w scenie
	for item in items_in_scen:
		# Porównaj nazwę przedmiotu z tymi w State.pick_up_items
		for picked_item in State.pick_up_items:
			if picked_item.item_name == item.item_name:
				items_to_remove.append(item)
				break
	# Usuń znalezione przedmioty
	for item in items_to_remove:
		items_in_scen[item].free()
		items_in_scen.erase(item)

func _process(_delta: float) -> void:
	if pointing_on == Cursors_above.NONE: return
	if Input.is_action_just_pressed("MovePlayer"):
		if _distance_to_item():
			match pointing_on:
				Cursors_above.STEEL_SHEET:
					_pick_up("steel_sheet",steel_sheet)
				Cursors_above.CRYSTAL_SHARD:
					_pick_up("crystal_shard", crystal_shard)
		else:

			var message: Array[String] = [
				"It's too far away, I can't reach it.",
				"I can't pick it up because it's out of my reach.",
				"That object is beyond my grasp.",
				"It's just a bit too far for me to get.",
				"I wish I could grab it, but it's too far away.",
				"I can't reach it from here.",
				"It's just outside my reach.",
				"I wish I could grab it, but it's too far away."
			]

			Signals.player_message.emit("Daniel",
				message[randi_range(0, message.size() - 1)]
			)
			State.state_phase -= 1

func _pick_up(item_name: String, _item: Item) -> void:
	_item.add_to_equipment()
	pointing_on = Cursors_above.NONE
	item_area[item_name].queue_free()


func _above_item(area: String) -> void:
	pointing_on = Cursors_above.get(area.to_upper())
	item_position = item_area[area].global_position
