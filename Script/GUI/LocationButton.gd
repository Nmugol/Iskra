extends Button

enum Locations{
	NONE,
	Shopping_Area,
	Residential_Area,
	Railway_Station,
	Mines,
	Town
}

@export_category("Location")
@export var location_scene_path: String = "res://Scenes/Locations/Mines/mines.tscn":
	set(value):
		location_scene_path = value
@export var location_position: Vector2 = Vector2.ZERO:
	set(value):
		location_position = value
@export var location: Locations = Locations.NONE:
	set(value):
		location = value
		var temp: String = Locations.keys()[location]
		text = temp.replace("_", " ")

@export var location_icon: CompressedTexture2D:
	set(value):
		location_icon = value
		icon = location_icon

@export_category("Visibility")
@export var disable_on_state: Array[int] = []
		
const  MAIN_SCENE = "res://Scenes/World.tscn"


func _on_pressed() -> void:
	Save.player_position = location_position
	Save.current_scene_path = location_scene_path
	get_tree().change_scene_to_file(MAIN_SCENE)

func _process(_delta: float) -> void:
	if disable_on_state.has(State.state_number):
		self.hide()
