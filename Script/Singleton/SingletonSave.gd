extends Node

const DATA_PATH: String = "user://save.json"
const SECURITY_KEY: String = "5422e6745a3d257e754364bdd07a323fcc2718f8140f0849b0719b59fd508921"

var current_scene_path: String = "res://Scenes/Locations/Mines/Mines.tscn":
	set(value):
		current_scene_path = value
	get:
		return current_scene_path

var player_position: Vector2 = Vector2(254, -75):
	set(value):
		player_position = value
	get:
		return player_position

var equipment: Array[Item] = []:
	set(value):
		if value == null:
			value = []
		equipment = value
		Signals.load_equipment.emit()
	get:
		return equipment


func is_in_equipment(i_name: String) -> bool:
	for i in Save.equipment:
		if i.item_name == i_name:
			return true
	return false


func remove_item(i_name: String) -> void:
	for i in Save.equipment:
		if i.item_name == i_name:
			i.remove_from_equipment()
		save_data_to_file()


func default_data() -> void:
	current_scene_path = "res://Scenes/Locations/Mines/Mines.tscn"
	player_position = Vector2(254, -75)
	equipment = []
	State.pick_up_items = []
	State.state_number = 0
	State.state_phase = 0
	State.pick_up_all_book = false
	State.pick_up_all_poster = false
	State.pick_up_books = []
	State.pick_up_poster = []


func _ready() -> void:
	Signals.save_to_file.connect(save_data_to_file)
	Signals.delete_save.connect(delete_save_file)
	load_data_from_file()


func load_data_from_file() -> void:
	if not FileAccess.file_exists(DATA_PATH):
		save_data_to_file()
		return

	var file = FileAccess.open_encrypted_with_pass(DATA_PATH, FileAccess.READ, SECURITY_KEY)

	if file:
		var data = JSON.parse_string(file.get_as_text())
		current_scene_path = data["current_scene_path"]
		player_position = Vector2(data["player_position"][0], data["player_position"][1])

		State.state_number = data["state_number"]
		State.state_phase = data["state_phase"]
		State.day_count = data["day_count"]

		State.pick_up_books = data["pick_up_books"]
		State.pick_up_all_book = data["pick_up_all_book"]

		State.pick_up_poster = data["pick_up_poster"]
		State.pick_up_all_poster = data["pick_up_all_poster"]

		for item in data["equipment"]:
			var new_item = Item.from_json(item)
			equipment.append(new_item)

		for item in data["pick_up_items"]:
			var new_item = Item.from_json(item)
			State.pick_up_items.append(new_item)
	file.close()


func save_data_to_file() -> void:
	var data = {
		"current_scene_path": current_scene_path,
		"player_position": [player_position.x, player_position.y],
		"state_number": State.state_number,
		"state_phase": State.state_phase,
		"day_count": State.day_count,
		"pick_up_books": State.pick_up_books,
		"pick_up_poster": State.pick_up_poster,
		"pick_up_all_poster": State.pick_up_all_poster,
		"pick_up_all_book": State.pick_up_all_book,
		"equipment": [],
		"pick_up_items": [],
	}

	for item in equipment:
		data["equipment"].append(item.to_json())

	for item in State.pick_up_items:
		data["pick_up_items"].append(item.to_json())

	var json = JSON.stringify(data, "\t")

	var file = FileAccess.open_encrypted_with_pass(DATA_PATH, FileAccess.WRITE, SECURITY_KEY)

	if file:
		file.store_string(json)
		file.close()


func delete_save_file() -> void:
	# Sprawdź, czy plik istnieje
	if FileAccess.file_exists(DATA_PATH):
		# Otwórz dostęp do katalogu (np. "user://")
		var dir = DirAccess.open("user://")

		if dir:
			# Usuń plik (używaj nazwy pliku, nie pełnej ścieżki)
			var error = dir.remove(DATA_PATH.get_file())
			if error == OK:
				default_data()
				save_data_to_file()
