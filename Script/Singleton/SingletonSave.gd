extends Node

const DATA_PATH: String = "user://save.json"
const SECURITY_KEY: String = "5422e6745a3d257e754364bdd07a323fcc2718f8140f0849b0719b59fd508921"

var CurrentScenePath: String = "res://Scenes/Locations/Mines/Mines.tscn": 
	set(value): CurrentScenePath = value
	get: return CurrentScenePath

var PlayerPosition: Vector2 = Vector2(254,-75):
	set(value): PlayerPosition = value
	get: return PlayerPosition

var Equipment: Array[Item] = []:
	set(value): 
		Equipment = value
		Signals.load_equiment.emit()
	get: return Equipment

func _is_in_equipment(i_name: String)-> bool:
	for i in Save.Equipment:
		if i.item_name == i_name: return true
	return false

func _remove_item(i_name: String) -> void:
	for i in Save.Equipment:
		if i.item_name == i_name: i.RemoveFromEquipment()
		SaveDataToFile()

func DefoultDate() -> void:
	CurrentScenePath = "res://Scenes/Locations/Mines/Mines.tscn"
	PlayerPosition = Vector2(254,-75)
	Equipment = []
	State.PickUpItems = []
	State.StateNumber = 0
	State.StatePhase = 0

func _ready()->void:
	Signals.save_to_file.connect(SaveDataToFile) 	
	Signals.delete_save.connect(delete_save_file)
	LoadDataFromFile()

func LoadDataFromFile()->void:

	if not FileAccess.file_exists(DATA_PATH):
		SaveDataToFile()
		return

	var file = FileAccess.open_encrypted_with_pass(DATA_PATH, FileAccess.READ,SECURITY_KEY)

	if file:
		var data = JSON.parse_string(file.get_as_text())
		CurrentScenePath = data["CurrentScenePath"]
		PlayerPosition = Vector2(data["PlayerPosition"][0], data["PlayerPosition"][1])
		
		State.StateNumber = data["StateNumber"]
		State.StatePhase = data["StatePhase"]
		
		for item in data["Equipment"]:
			var new_item = Item.FromJson(item)
			Equipment.append(new_item)
		
		for item in data["PickUpItems"]:
			var new_item = Item.FromJson(item)
			State.PickUpItems.append(new_item)
		
	else:
		print("Bład otwarcia pliku")
	file.close()

func SaveDataToFile()->void:

	var data = {
		"CurrentScenePath": CurrentScenePath,
		"PlayerPosition": [PlayerPosition.x, PlayerPosition.y],
		"StateNumber": State.StateNumber,
		"StatePhase": State.StatePhase, 
		"Equipment": [],
		"PickUpItems": []
	}
	
	for item in Equipment:
		data["Equipment"].append(item.ToJson())
	
	for item in State.PickUpItems:
		data["PickUpItems"].append(item.ToJson())
		

	var json = JSON.stringify(data, "\t")

	var file = FileAccess.open_encrypted_with_pass(DATA_PATH,FileAccess.WRITE,SECURITY_KEY)
	
	if file:
		file.store_string(json)
		file.close()
	else:
		print("Bład otwarcia pliku i zapisu")


func delete_save_file() -> void:
	# Sprawdź, czy plik istnieje
	if FileAccess.file_exists(DATA_PATH):
		# Otwórz dostęp do katalogu (np. "user://")
		var dir = DirAccess.open("user://")
		
		if dir:
			# Usuń plik (używaj nazwy pliku, nie pełnej ścieżki)
			var error = dir.remove(DATA_PATH.get_file())
			if error == OK:
				DefoultDate()
				SaveDataToFile()
			else: print("Błąd podczas usuwania pliku: ", error)
		else: print("Błąd dostępu do katalogu.")
	else: print("Plik nie istnieje.")
