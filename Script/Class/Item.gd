class_name Item extends Node

var item_name: String =""
var contains_items: Array[Item] = []
var is_finished: bool = true
var small_sprite_path: String = ""
var full_sprite_path: String = ""
var connects_with: Array[String] = []

func _init(itemName: String, containsItems: Array[Item], isFinished: bool, smallSpritePath: String, fullSpritePath: String, connectsWith: Array[String]) -> void:
	item_name = itemName
	contains_items = containsItems
	is_finished = isFinished
	small_sprite_path = smallSpritePath
	full_sprite_path = fullSpritePath
	connects_with = connectsWith

func ToJson() -> Dictionary:

	var json_data := {
		"item_name": item_name,
		"contains_items": [],
		"is_finished": is_finished,
		"small_sprite_path": small_sprite_path,
		"full_sprite_path": full_sprite_path,
		"connects_with": connects_with
	}
	
	for item in contains_items:
		json_data["contains_items"].append(item.ToJson()) 
	
	return json_data


static func FromJson(json_data: Dictionary) -> Item:
	# Prepare an empty Array[Item] for contains_items
	var contains_items_arr: Array[Item] = []
	
	# Convert connects_with data to Array[String]
	var connects_with_data: Array = json_data.get("connects_with", [])
	var connects_with_arr: Array[String] = []
	for entry in connects_with_data:
		connects_with_arr.append(str(entry))
	
	# Create the Item instance with properly typed arrays
	var item := Item.new(
		json_data.get("item_name", ""),
		contains_items_arr,  # Array[Item]
		json_data.get("is_finished", true),
		json_data.get("small_sprite_path", ""),
		json_data.get("full_sprite_path", ""),
		connects_with_arr    # Array[String]
	)
	
	# Recursively populate contains_items
	for item_data in json_data.get("contains_items", []):
		item.contains_items.append(FromJson(item_data))
	
	return item

func AddToEquipment() -> void:
	Save.Equipment.append(self)
	State.PickUpItems.append(self)

func RemoveFromEquipment() -> void:
	Save.Equipment.erase(self)

func Assemble(itemToCombine: Item) -> void:
	# Zabezpieczenie przed null'em
	if not is_instance_valid(itemToCombine):
		return
	
	# Zabezpieczenie przed łączeniem z samym sobą
	if itemToCombine == self or itemToCombine.item_name == self.item_name:
		return
	
	# Zabezpieczenie przed duplikatami
	if contains_items.has(itemToCombine):
		return
	
	if connects_with.has(itemToCombine.item_name) and is_finished:
		contains_items.append(itemToCombine)
		itemToCombine.RemoveFromEquipment()

func Disassemble() -> void:
	for item:Item in contains_items:
		item.is_finished = true
		Save.Equipment.push_back(item)
	Save.Equipment.erase(self)

	Signals.load_equiment.emit()
	Signals.look_at_item.emit(Save.Equipment[len(Save.Equipment)-1])
