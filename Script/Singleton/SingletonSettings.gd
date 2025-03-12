extends Node

var IsRun: bool = true

const DATA_PATH: String = "user://settings.json"

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

var MasterVolume: float = 1.0:
	set(value):
		MasterVolume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	get: return MasterVolume

var MusicVolume: float = 1.0:
	set(value):
		MusicVolume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	get: return MusicVolume

var SoundEffectsVolume: float = 1.0:
	set(value):
		SoundEffectsVolume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), linear_to_db(value))
	get: return SoundEffectsVolume


func saveSettings() -> void:
	var date = {
		"ResolutionIndex": ResolutionIndex,
		"ScreenResolution": ScreenResolutionOptions[ResolutionIndex],
		"WindowType": WindowType,
		"MasterVolume": MasterVolume,
		"MusicVolume": MusicVolume,
		"SoundEffectsVolume": SoundEffectsVolume
	}

	var json = JSON.stringify(date, "\t")

	var file = FileAccess.open(DATA_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()
	else:
		print("Error")

func loadSettings() -> void:

	if not FileAccess.file_exists(DATA_PATH):
		saveSettings()
		return

	var file = FileAccess.open(DATA_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())

		var resindx = ScreenResolutionOptions.find(data["ScreenResolution"])
		
		var res = data["ScreenResolution"].split("x")
		ScreenResolution = Vector2(int(res[0]), int(res[1]))
		if resindx == data["ResolutionIndex"]:
			ResolutionIndex = data["ResolutionIndex"]
		else :
			ResolutionIndex = resindx
		WindowType = data["WindowType"]

		MasterVolume = data["MasterVolume"]
		MusicVolume = data["MusicVolume"]
		SoundEffectsVolume = data["SoundEffectsVolume"]

		file.close()
	else:
		print("Error")

func resetSettings() -> void:
	
	WindowType = 0
	ScreenResolution = Vector2(1280, 720)
	ResolutionIndex = 0	
	
	MasterVolume = 1.0
	MusicVolume = 1.0
	SoundEffectsVolume = 1.0
	saveSettings()

func _ready() -> void:
	loadSettings()
