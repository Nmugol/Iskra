extends Button

@export var location_scene_path: String = "res://Scenes/Locations/Mines/mines.tscn"
@export var location_position: Vector2
@export var location_name: String = "location":
	set(value):
		location_name = value
		text = value
@export var location_active_on_stage: Array[int] = []

@export var location_icon: CompressedTexture2D:
	set(value):
		location_icon = value
		icon = location_icon
		
const  MAIN_SCENE = "res://Scenes/World.tscn"

func _ready() -> void:
	change_visibility()

func change_visibility() -> void:
	hide()
	if location_active_on_stage.has(State.state_number):
		show()
	if Save.current_scene_path == location_scene_path:
		hide()

func _on_pressed() -> void:
	Save.player_position = location_position
	Save.current_scene_path = location_scene_path
	get_tree().change_scene_to_file(MAIN_SCENE)
