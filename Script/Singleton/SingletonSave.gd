extends Node

const DATA_PATH: String = "user://save.json"

var CurrentScenePath: String = "res://Scenes/Locations/Mines/mines.tscn": 
	set(value): CurrentScenePath = value
	get: return CurrentScenePath

var PlayerPosition: Vector2 = Vector2(0,0):
	set(value): PlayerPosition = value
	get: return PlayerPosition

var Equipment: Array[Item] = []:
	set(value): 
		Equipment = value
		Signals.load_equiment.emit()
	get: return Equipment

func _ready()->void:
	Signals.save_to_file.connect(SaveDataToFile) 	
	LoadDataFromFile()

func LoadDataFromFile()->void:

	if not FileAccess.file_exists(DATA_PATH):
		SaveDataToFile()
		return

	var file = FileAccess.open(DATA_PATH, FileAccess.READ)

	if file:
		var data = JSON.parse_string(file.get_as_text())
		CurrentScenePath = data["CurrentScenePath"]
		PlayerPosition = Vector2(data["PlayerPosition"][0], data["PlayerPosition"][1])
		
		for item in data["Equipment"]:
			var new_item = Item.FromJson(item)
			Equipment.append(new_item)
	else:
		print("Bład otwarcia pliku")
	file.close()

func SaveDataToFile()->void:

	var data = {
		"CurrentScenePath": CurrentScenePath,
		"PlayerPosition": [PlayerPosition.x, PlayerPosition.y],
		"Equipment": []
	}
	
	for item in Equipment:
		data["Equipment"].append(item.ToJson())
		

	var json = JSON.stringify(data, "\t")

	var file = FileAccess.open(DATA_PATH, FileAccess.WRITE)

	if file:
		file.store_string(json)
	else:
		print("Bład otwarcia pliku i zapisu")
	file.close()
