class_name Item
extends Node

var item_name: String = ""
var contains_items: Array[Item] = []
var is_finished: bool = true
var small_sprite_path: String = ""
var full_sprite_path: String = ""
var connects_with: Array[String] = []
var result_name: String = ""
var result_small_sprite_path: String = ""
var result_full_sprite_path: String = ""
var result_connects_with: Array[String] = []
var result_is_finished: bool = true

var oryginale_name: String = ""
var oryginale_small_sprite_path: String = ""
var oryginale_full_sprite_path: String = ""


func _init(
		itemName: String,
		containsItems: Array[Item],
		isFinished: bool,
		smallSpritePath: String,
		fullSpritePath: String,
		connectsWith: Array[String],
		resultName: String = "",
		resultSmallSpritePath: String = "",
		resultFullSpritePath: String = "",
		resultConnectsWith: Array[String] = [],
		resultIsFinished: bool = true,
) -> void:
	item_name = itemName
	contains_items = containsItems
	is_finished = isFinished
	small_sprite_path = smallSpritePath
	full_sprite_path = fullSpritePath
	connects_with = connectsWith
	result_name = resultName
	result_small_sprite_path = resultSmallSpritePath
	result_full_sprite_path = resultFullSpritePath
	result_connects_with = resultConnectsWith
	result_is_finished = resultIsFinished
	oryginale_full_sprite_path = fullSpritePath
	oryginale_name = itemName
	oryginale_small_sprite_path = smallSpritePath


func to_json() -> Dictionary:
	var json_data := {
		"item_name": item_name,
		"contains_items": [],
		"is_finished": is_finished,
		"small_sprite_path": small_sprite_path,
		"full_sprite_path": full_sprite_path,
		"connects_with": connects_with,
		"result_name": result_name,
		"result_small_sprite_path": result_small_sprite_path,
		"result_full_sprite_path": result_full_sprite_path,
		"result_connects_with": result_connects_with,
		"result_is_finished": result_is_finished,
		"oryginale_name": oryginale_name,
		"oryginale_small_sprite_path": oryginale_small_sprite_path,
		"oryginale_full_sprite_path": oryginale_full_sprite_path
	}

	for item in contains_items:
		json_data["contains_items"].append(item.to_json())

	return json_data


static func from_json(json_data: Dictionary) -> Item:
	var contains_items_arr: Array[Item] = []

	var connects_with_data: Array = json_data.get("connects_with", [])
	var connects_with_arr: Array[String] = []
	for entry in connects_with_data:
		connects_with_arr.append(str(entry))

	var result_connects_with_data: Array = json_data.get("result_connects_with", [])
	var result_connects_with_arr: Array[String] = []
	for entry in result_connects_with_data:
		result_connects_with_arr.append(str(entry))

	var item := Item.new(
		json_data.get("item_name", ""),
		contains_items_arr, # Array[Item]
		json_data.get("is_finished", true),
		json_data.get("small_sprite_path", ""),
		json_data.get("full_sprite_path", ""),
		connects_with_arr,
		json_data.get("result_name", ""),
		json_data.get("result_small_sprite_path", ""),
		json_data.get("result_full_sprite_path", ""),
		result_connects_with_arr,
		json_data.get("result_is_finished", true),
	)

	item.oryginale_name = json_data.get("oryginale_name","")
	item.oryginale_full_sprite_path = json_data.get("oryginale_full_sprite_path","")
	item.oryginale_small_sprite_path = json_data.get("oryginale_small_sprite_path","")

	for item_data in json_data.get("contains_items", []):
		item.contains_items.append(from_json(item_data))

	return item


func add_to_equipment() -> void:
	Save.equipment.append(self)
	State.pick_up_items.append(self)


func remove_from_equipment() -> void:
	Save.equipment.erase(self)


func assemble(item_to_combine: Item) -> void:
	if not is_instance_valid(item_to_combine):
		return

	if item_to_combine == self or item_to_combine.item_name == self.item_name:
		return

	if contains_items.has(item_to_combine):
		return

	if connects_with.has(item_to_combine.item_name) and is_finished:
		contains_items.append(item_to_combine)
		item_to_combine.remove_from_equipment()

		if _is_crafting_complete():
			_morph_into_result_item()


func disassemble() -> void:
	for item: Item in contains_items:
		item.is_finished = true
		Save.equipment.push_back(item)

	self.name = oryginale_name
	self.small_sprite_path = oryginale_small_sprite_path
	self.full_sprite_path = oryginale_full_sprite_path

	Signals.load_equipment.emit()
	Signals.look_at_item.emit(Save.equipment[len(Save.equipment) - 1])


func _is_crafting_complete() -> bool:
	if connects_with.is_empty():
		return false

	if contains_items.size() != connects_with.size():
		return false

	var contained_names: Array[String] = []
	for item in contains_items:
		contained_names.append(item.item_name)

	for required_name in connects_with:
		if not contained_names.has(required_name):
			return false

	return true


func _morph_into_result_item() -> void:
	if result_name == "":
		print("Przedmiot kompletny, ale 'result_name' nie jest zdefiniowane. Nie można przekształcić.")
		return

	print("Przedmiot skompletowany! Przekształcanie w: ", result_name)

	self.item_name = self.result_name
	self.small_sprite_path = self.result_small_sprite_path
	self.full_sprite_path = self.result_full_sprite_path

	self.connects_with = self.result_connects_with

	self.is_finished = self.result_is_finished
	Signals.load_equipment.emit()
