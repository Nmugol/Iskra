extends Node

@export var player: Player
const PICK_UP_DISTANCE: float = 40

@export var item_area: Dictionary[String,Area2D]
var Items_in_scen: Dictionary[Item, Area2D]

enum curson_above{
	STEEL_SHEET,
	NONE
}
var pointin_on: curson_above = curson_above.NONE

var item_position: Vector2

var steel_sheet: Item = Item.new("Steel sheet",[],true,"res://icon.svg","res://icon.svg",[])

func _distance_to_item() -> bool:
	if player.global_position.distance_to(item_position) <= PICK_UP_DISTANCE:
		return true
	return false

func _ready() -> void:
	Items_in_scen[steel_sheet] = item_area["steel_sheet"]
	
	Signals.mouse_off_item.connect(func ():
		pointin_on = curson_above.NONE
		)
	
	Signals.mouse_above_item.connect(_above_item)
	
	_remove_alredy_pickup_item()



func _remove_alredy_pickup_item() -> void:
	var items_to_remove := []
	# Sprawdź każdy przedmiot w scenie
	for item in Items_in_scen:
		# Porównaj nazwę przedmiotu z tymi w State.PickUpItems
		for picked_item in State.PickUpItems:
			if picked_item.item_name == item.item_name:
				items_to_remove.append(item)
				break
	# Usuń znalezione przedmioty
	for item in items_to_remove:
		Items_in_scen[item].free()
		Items_in_scen.erase(item)

func _process(_delta: float) -> void:
	if pointin_on == curson_above.NONE: return
	if Input.is_action_just_pressed("MovePlayer") and _distance_to_item():
		match pointin_on:
			curson_above.STEEL_SHEET:
				steel_sheet.AddToEquipment()
				pointin_on = curson_above.NONE
				
				item_area["steel_sheet"].queue_free()

func _above_item(area: String) -> void:
	pointin_on = curson_above.get(area.to_upper())
	item_position = item_area[area].global_position
