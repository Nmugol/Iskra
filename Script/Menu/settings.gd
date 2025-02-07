extends Control

var MainScene = "res://Scenes/Menu/main_menu.tscn"
@export_group("Window Settings")
@export var ResolutionButton: OptionButton
@export var WindowTypeButton: OptionButton

@export_group("Audio Settings")
@export var MasterSlider: HSlider
@export var MasterSliderLabel: Label

@export var MusicSlider: HSlider
@export var MusicSliderLabel: Label

@export var SoundEffectsSlider: HSlider
@export var SoundEffectsSliderLabel: Label

func _ready() -> void:
	setUp()

func setUp() -> void:
	for resolution in SingletonSettings.ScreenResolutionOptions:
		ResolutionButton.add_item(resolution)	
	ResolutionButton.selected = SingletonSettings.ResolutionIndex

	for windowType in SingletonSettings.WindowTypeOptions:
		WindowTypeButton.add_item(windowType)
	WindowTypeButton.selected = SingletonSettings.WindowType

	MasterSlider.value = SingletonSettings.MasterVolume
	MusicSlider.value = SingletonSettings.MusicVolume
	SoundEffectsSlider.value = SingletonSettings.SoundEffectsVolume

	updateLabels()

func _on_resolution_button_item_selected(index:int) -> void:
	SingletonSettings.ResolutionIndex = index
	var res = SingletonSettings.ScreenResolutionOptions[index].split("x")
	SingletonSettings.ScreenResolution = Vector2(int(res[0]), int(res[1]))
	
	SingletonSettings.saveSettings()

func _on_window_type_button_item_selected(index:int) -> void:
	SingletonSettings.WindowType = index
	
	SingletonSettings.saveSettings()


func _on_mian_menu_button_down() -> void:
	get_tree().change_scene_to_file(MainScene)


func _on_reset_button_down() -> void:
	SingletonSettings.resetSettings()
	ResolutionButton.selected = 0
	WindowTypeButton.selected = 0

	MasterSlider.value = 1
	MusicSlider.value = 1
	SoundEffectsSlider.value = 1

func _on_master_slider_value_changed(value:float) -> void:
	SingletonSettings.MasterVolume = value
	SingletonSettings.saveSettings()
	updateLabels()


func _on_sound_efects_slider_value_changed(value:float) -> void:
	SingletonSettings.SoundEffectsVolume = value
	SingletonSettings.saveSettings()
	updateLabels()


func _on_music_slider_value_changed(value:float) -> void:
	SingletonSettings.MusicVolume = value
	SingletonSettings.saveSettings()
	updateLabels()

func updateLabels() -> void:
	MusicSliderLabel.text = str(SingletonSettings.MusicVolume*100)+"%"
	SoundEffectsSliderLabel.text = str(SingletonSettings.SoundEffectsVolume*100)+"%"
	MasterSliderLabel.text = str(SingletonSettings.MasterVolume*100)+"%"