@tool
extends Button


@export var LocationSceenPath: String = "res://Scenes/Locations/Mines/mines.tscn"
@export var LocationName: String = "location":
	set(value):
		LocationName = value
		text = value
@export var LocationActiveOnStage: Array[int] = []

@export var LocationIcon: CompressedTexture2D:
	set(value):
		LocationIcon = value
		icon = LocationIcon

func _ready() -> void:
	changeVizibility()

func changeVizibility() -> void:
	hide()
	if LocationActiveOnStage.has(State.StateNumber):
		show()

func _on_pressed() -> void:
	Save.CurrentScenePath = LocationSceenPath
	Signals.change_scene.emit()
