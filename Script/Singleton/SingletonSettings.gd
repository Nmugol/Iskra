extends Node

var ScreenResolutionOptions: Array[String] = [
	"1280x720", 
	"1600x1200", "1920x1080", "2560x1440", 
	"3840x2160", "4096x2160"
]

var ResolutionIndex: int = 0

var ScreenResolution: Vector2 = Vector2(1280, 720):
	set(value): 
		ScreenResolution = value
		DisplayServer.window_set_size(value)
	get: return ScreenResolution

var WindowTypeOptions: Array[String] = [
	"Windowed", "Fullscreen", "Borderless", "FullscreenBorderless"
]

var WindowType: int = 0:
	set(value): 
		WindowType = value
		
		match value:
			0: # Okienkowy
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
				
			1: # Pełny ekran
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				
			2: # Bezramkowy
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
				
			3: # Pełny ekran bezramkowy
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	get: return WindowType

func saveSettings() -> void:
	var date = {
		"ResolutionIndex": ResolutionIndex,
		"ScreenResolution": ScreenResolutionOptions[ResolutionIndex],
		"WindowType": WindowType
	}

	var json = JSON.stringify(date, "\t")

	var file = FileAccess.open("res://settings.json", FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()
	else:
		print("Error")

func loadSettings() -> void:

	if not FileAccess.file_exists("res://settings.json"):
		saveSettings()
		return

	var file = FileAccess.open("res://settings.json", FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())

		var res = data["ScreenResolution"].split("x")
		ScreenResolution = Vector2(int(res[0]), int(res[1]))
		ResolutionIndex = data["ResolutionIndex"]
		WindowType = data["WindowType"]

		file.close()
	else:
		print("Error")

func resetSettings() -> void:
	
	WindowType = 0
	ScreenResolution = Vector2(1280, 720)
	ResolutionIndex = 0

	
	saveSettings()

	DisplayServer.window_set_size(Vector2(1280, 720))

func _ready() -> void:
	loadSettings()