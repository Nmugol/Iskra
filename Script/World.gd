extends SubViewportContainer

@export var LevelLoader: SubViewport
@export var nextLevel: String = "res://Scenes/Locations/Mines/node_4.tscn"

func _ready()->void:
	LoadLevel()
	
func LoadLevel() -> void:
	if(LevelLoader.get_child_count()>0):
		var i =LevelLoader.get_child(0)
		i.queue_free()
		
	var levelnode = load(Save.CurrentScenePath).instantiate()
	LevelLoader.add_child(levelnode)

func SaveLevel() -> void:
	Save.CurrentScenePath = LevelLoader.get_child(0).get_path()


func _on_button_button_down() -> void:
	Save.CurrentScenePath = nextLevel
	LoadLevel()
