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

func _ready()->void:
	Signals.save_to_file.connect(SaveDataToFile) 	
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
	else:
		print("Bład otwarcia pliku")
	file.close()

func SaveDataToFile()->void:

	var data = {
		"CurrentScenePath": CurrentScenePath,
		"PlayerPosition": [PlayerPosition.x, PlayerPosition.y],
		"StateNumber": State.StateNumber,
		"StatePhase": State.StatePhase, 
		"Equipment": []
	}
	
	for item in Equipment:
		data["Equipment"].append(item.ToJson())
		

	var json = JSON.stringify(data, "\t")

	var file = FileAccess.open_encrypted_with_pass(DATA_PATH,FileAccess.WRITE,SECURITY_KEY)
	
	if file:
		file.store_string(json)
		file.close()
	else:
		print("Bład otwarcia pliku i zapisu")
	
