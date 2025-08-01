extends Node

const DATA_PATH: String = "user://settings.json"

var screen_resolution_options: Array[String] = [
	"1280x720", 
	"1600x1200", "1920x1080", "2560x1440", 
	"3840x2160", "4096x2160"
]

var resolution_index: int = 0

var screen_resolution: Vector2 = Vector2(1280, 720):
	set(value): 
		screen_resolution = value
		DisplayServer.window_set_size(value)
	get: return screen_resolution

var window_type_options: Array[String] = [
	"Windowed", "Fullscreen", "Borderless", "FullscreenBorderless"
]

var window_type: int = 0:
	set(value): 
		window_type = value
		
		match value:
			0: # Okienkowy
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
				
			1: # Pełny ekran
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
				
			2: # Bez ramek
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
				DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
				
			3: # Pełny ekran bez ramek
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	get: return window_type

var master_volume: float = 1.0:
	set(value):
		master_volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	get: return master_volume

var music_volume: float = 1.0:
	set(value):
		music_volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	get: return music_volume

var sound_effects_volume: float = 1.0:
	set(value):
		sound_effects_volume = value
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SoundEffects"), linear_to_db(value))
	get: return sound_effects_volume


func save_settings() -> void:
	var data = {
		"resolution_index": resolution_index,
		"screen_resolution": screen_resolution_options[resolution_index],
		"window_type": window_type,
		"master_volume": master_volume,
		"music_volume": music_volume,
		"sound_effects_volume": sound_effects_volume
	}

	var json = JSON.stringify(data, "\t")

	var file = FileAccess.open(DATA_PATH, FileAccess.WRITE)
	if file:
		file.store_string(json)
		file.close()
	else:
		print("Error")

func load_settings() -> void:

	if not FileAccess.file_exists(DATA_PATH):
		save_settings()
		return

	var file = FileAccess.open(DATA_PATH, FileAccess.READ)
	if file:
		var data = JSON.parse_string(file.get_as_text())

		var _resolution_index = screen_resolution_options.find(data["screen_resolution"])
		
		var resolution = data["screen_resolution"].split("x")
		screen_resolution = Vector2(int(resolution[0]), int(resolution[1]))
		if _resolution_index == data["resolution_index"]:
			resolution_index = data["resolution_index"]
		else :
			resolution_index = _resolution_index
		window_type = data["window_type"]

		master_volume = data["master_volume"]
		music_volume = data["music_volume"]
		sound_effects_volume = data["sound_effects_volume"]

		file.close()
	else:
		print("Error")

func resetSettings() -> void:
	
	window_type = 0
	screen_resolution = Vector2(1280, 720)
	resolution_index = 0	
	
	master_volume = 1.0
	music_volume = 1.0
	sound_effects_volume = 1.0
	save_settings()

func _reset_cursor() -> void:
	Input.set_custom_mouse_cursor(load("res://Sprite/Cursors/tile_0177.png"),Input.CURSOR_ARROW,Vector2(8,8))

func _set_cursor(cursor_name: State.Cursors = State.Cursors.DEFAULT) -> void:
	match  cursor_name:
		State.Cursors.USE:
			Input.set_custom_mouse_cursor(load("res://Sprite/Cursors/tile_0132.png"),Input.CURSOR_ARROW,Vector2(8,8))
		State.Cursors.PICKUP:
			Input.set_custom_mouse_cursor(load("res://Sprite/Cursors/tile_0135.png"),Input.CURSOR_ARROW,Vector2(8,8))
		State.Cursors.WALK:
			Input.set_custom_mouse_cursor(load("res://Sprite/Cursors/tile_0098.png"),Input.CURSOR_ARROW,Vector2(8,8))
		State.Cursors.DEFAULT:
			Input.set_custom_mouse_cursor(load("res://Sprite/Cursors/tile_0177.png"),Input.CURSOR_ARROW,Vector2(8,8))
		_:
			_reset_cursor()


func _ready() -> void:
	Signals.set_cursor.connect(_set_cursor)
	Signals.reset_cursor.connect(_reset_cursor)
	_reset_cursor()
	load_settings()
