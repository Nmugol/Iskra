extends Node

enum curson_above{
	STEEL_SHEET,
	NONE
}

var pointin_on: curson_above = curson_above.NONE
var item_position: Vector2

@export var player: Player

const PICK_UP_DISTANCE: float = 40

func _distance_to_item() -> bool:
	if player.global_position.distance_to(item_position) <= PICK_UP_DISTANCE:
		return true
	return false

func _process(_delta: float) -> void:
	if pointin_on == curson_above.NONE: return
	if Input.is_action_just_pressed("MovePlayer") and _distance_to_item():
		match pointin_on:
			curson_above.STEEL_SHEET:
				var steel_sheet: Item = Item.new("Steel sheet",[],true,"res://icon.svg","res://icon.svg",[])
				steel_sheet.AddToEquipment()
				pointin_on = curson_above.NONE
				$SteelSheet.free()

func _on_steel_sheet_mouse_entered() -> void:
	pointin_on = curson_above.STEEL_SHEET
	item_position = $SteelSheet.global_position


func _on_steel_sheet_mouse_exited() -> void:
	pointin_on = curson_above.NONE
