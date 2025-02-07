extends Node

const DATA_PATH: String = "user://save.json"

var CurrentSceneName: String = "": 
	set(value): CurrentSceneName = value
	get: return CurrentSceneName

var PlayerPosition: Vector2 = Vector2(0,0):
	set(value): PlayerPosition = value
	get: return PlayerPosition

var Equipment: Array = []:
	set(value): Equipment = value
	get: return Equipment



func _ready()->void:	
	loadData()

func loadData()->void:

	if not FileAccess.file_exists(DATA_PATH):
		saveData()
		return

	var file = FileAccess.open(DATA_PATH, FileAccess.READ)

	if file:
		var data = JSON.parse_string(file.get_as_text())

		print(data)
		
		CurrentSceneName = data["CurrentSceneName"]
		PlayerPosition = Vector2(data["PlayerPosition"][0], data["PlayerPosition"][1])

		Equipment = data["Equipment"]
	else:
		print("Bład otwarcia pliku")
	file.close()

func saveData()->void:

	var data = {
		"CurrentSceneName": CurrentSceneName,
		"PlayerPosition": [PlayerPosition.x, PlayerPosition.y],
		"Equipment": Equipment
	}

	var json = JSON.stringify(data, "\t")

	var file = FileAccess.open(DATA_PATH, FileAccess.WRITE)

	if file:
		file.store_string(json)
	else:
		print("Bład otwarcia pliku i zapisu")
	file.close()
