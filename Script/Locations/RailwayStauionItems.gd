extends Node

enum curson_above{
	STEEL_SHEET,
	NONE
}

var pointin_on: curson_above = curson_above.NONE
var item_position: Vector2

@export var player: Player

var Items_in_scen: Dictionary[Item, Area2D]

const PICK_UP_DISTANCE: float = 40

var steel_sheet: Item

func _distance_to_item() -> bool:
	if player.global_position.distance_to(item_position) <= PICK_UP_DISTANCE:
		return true
	return false

func _ready() -> void:
	steel_sheet = Item.new("Steel sheet",[],true,"res://icon.svg","res://icon.svg",[])
	
	Items_in_scen[steel_sheet] = $SteelSheet
	
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
				$SteelSheet.queue_free()

func _on_steel_sheet_mouse_entered() -> void:
	pointin_on = curson_above.STEEL_SHEET
	item_position = $SteelSheet.global_position

func _on_steel_sheet_mouse_exited() -> void:
	pointin_on = curson_above.NONE
