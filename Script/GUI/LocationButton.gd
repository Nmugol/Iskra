@tool
extends Button

@export var LocationSceenPath: String = "res://Scenes/Locations/Mines/mines.tscn"
@export var LocationName: String = "location":
	set(value):
		LocationName = value
		text = value

@export var LocationIcon: CompressedTexture2D:
	set(value):
		LocationIcon = value
		icon = LocationIcon

#func _ready() -> void:
	#icon = LocationIcon

func _on_pressed() -> void:
	pass # Replace with function body.
