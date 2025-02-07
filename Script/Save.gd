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



func _ready()->void:	
	loadData()

func loadData()->void:

	# Sprawda czy plik istnieje
	if not FileAccess.file_exists("res://save.json"):
		saveData()
		return

	# Otwiera plik
	var file = FileAccess.open("res://save.json", FileAccess.READ)

	# Poprawne otwarcie
	if file:

		# Przetwarza plik
		var data = JSON.parse_string(file.get_as_text())

		print(data)
		
		CurrentSceneName = data["CurrentSceneName"]
		PlayerPosition = Vector2(data["PlayerPosition"][0], data["PlayerPosition"][1])

		Equipment = data["Equipment"]

	# Niepoprawne otwarcie
	else:
		print("Bład otwarcia pliku")

	# Zamyka plik
	file.close()

func saveData()->void:

	# Tworzy obiekt do zapisu
	var data = {
		"CurrentSceneName": CurrentSceneName,
		"PlayerPosition": [PlayerPosition.x, PlayerPosition.y],
		"Equipment": Equipment
	}

	# Formatuje obiekt do formatu JSON
	var json = JSON.stringify(data, "\t")

	# Otwiera plik
	var file = FileAccess.open("res://save.json", FileAccess.WRITE)

	# Poprawne otwarcie
	if file:
		# Zapisuje
		file.store_string(json)
	else:
		print("Bład otwarcia pliku i zapisu")

	# Zamyka plik
	file.close()
