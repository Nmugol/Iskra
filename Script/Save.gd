extends Node

var CurrentSceneName: String = "": 
	set(value): CurrentSceneName = value
	get: return CurrentSceneName

var PlayerPosition: Vector2 = Vector2(0,0):
	set(value): PlayerPosition = value
	get: return PlayerPosition

var Equipment: Array = []:
	set(value): Equipment = value
	get: return Equipment

var ScreenResolution: Vector2 = Vector2(1280,720):
	set(value): 
		ScreenResolution = value
		DisplayServer.window_set_size(value)
	get: return ScreenResolution

var WindowType: int = 0:
	set(value): WindowType = value
	get: return WindowType

func _ready()->void:	
	loadData()

func loadData()->void:

	# Sprawda czy plik istnieje
	if not FileAccess.file_exists("user://save.json"):
		saveData()
		return

	# Otwiera plik
	var file = FileAccess.open("user://save.json", FileAccess.READ)

	# Poprawne otwarcie
	if file:

		# Odczytuje plik
		var json = file.get_as_text()

		# Przetwarza plik
		var data = JSON.parse_string(json)
		
		CurrentSceneName = data["CurrentSceneName"]
		PlayerPosition = Vector2(data["PlayerPosition"][0], data["PlayerPosition"][1])

		ScreenResolution = Vector2(data["ScreenResolution"][0], data["ScreenResolution"][1])
		WindowType = data["WindowType"]

		Equipment = data["Equipment"]

	# Niepoprawne otwarcie
	else:
		print("Bład otwarcia pliku")

	# Zamyka plik
	file.close()

func saveData()->void:

	# Tworzy obiekt do zapisu
	var data = {
		"ScreenResolution": [ScreenResolution.x, ScreenResolution.y],
		"WindowType": WindowType,
		"CurrentSceneName": CurrentSceneName,
		"PlayerPosition": [PlayerPosition.x, PlayerPosition.y],
		"Equipment": Equipment
	}

	# Formatuje obiekt do formatu JSON
	var json = JSON.stringify(data, "\t")

	# Otwiera plik
	var file = FileAccess.open("user://save.json", FileAccess.WRITE)

	# Poprawne otwarcie
	if file:
		# Zapisuje
		file.store_string(json)
	else:
		print("Bład otwarcia pliku i zapisu")

	# Zamyka plik
	file.close()
