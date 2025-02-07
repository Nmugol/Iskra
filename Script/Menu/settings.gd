extends Control

var MainScene = "res://Scenes/Menu/main_menu.tscn"
@export var ResolutionButton: OptionButton
@export var WindowTypeButton: OptionButton

func _ready() -> void:
	setUp()

func setUp() -> void:
	for resolution in SingletonSettings.ScreenResolutionOptions:
		ResolutionButton.add_item(resolution)	
	ResolutionButton.selected = SingletonSettings.ResolutionIndex

	for windowType in SingletonSettings.WindowTypeOptions:
		WindowTypeButton.add_item(windowType)
	WindowTypeButton.selected = SingletonSettings.WindowType

func _on_resolution_button_item_selected(index:int) -> void:
	SingletonSettings.ResolutionIndex = index
	var res = SingletonSettings.ScreenResolutionOptions[index].split("x")
	SingletonSettings.ScreenResolution = Vector2(int(res[0]), int(res[1]))
	
	SingletonSettings.saveSettings()

func _on_window_type_button_item_selected(index:int) -> void:
	SingletonSettings.WindowType = index


func _on_mian_menu_button_down() -> void:
	get_tree().change_scene_to_file(MainScene)


func _on_reset_button_down() -> void:
	SingletonSettings.resetSettings()
	ResolutionButton.selected = 0
	WindowTypeButton.selected = 0