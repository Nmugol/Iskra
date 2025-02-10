extends Control

var MainScene = "res://Scenes/Menu/MainMenu.tscn"
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
	for resolution in Settings.ScreenResolutionOptions:
		ResolutionButton.add_item(resolution)	
	ResolutionButton.selected = Settings.ResolutionIndex

	for windowType in Settings.WindowTypeOptions:
		WindowTypeButton.add_item(windowType)
	WindowTypeButton.selected = Settings.WindowType

	MasterSlider.value = Settings.MasterVolume
	MusicSlider.value = Settings.MusicVolume
	SoundEffectsSlider.value = Settings.SoundEffectsVolume

	updateLabels()

func _on_resolution_button_item_selected(index:int) -> void:
	Settings.ResolutionIndex = index
	var res = Settings.ScreenResolutionOptions[index].split("x")
	Settings.ScreenResolution = Vector2(int(res[0]), int(res[1]))
	
	Settings.saveSettings()

func _on_window_type_button_item_selected(index:int) -> void:
	Settings.WindowType = index
	
	Settings.saveSettings()


func _on_mian_menu_button_down() -> void:
	get_tree().change_scene_to_file(MainScene)


func _on_reset_button_down() -> void:
	Settings.resetSettings()
	ResolutionButton.selected = 0
	WindowTypeButton.selected = 0

	MasterSlider.value = 1
	MusicSlider.value = 1
	SoundEffectsSlider.value = 1

func _on_master_slider_value_changed(value:float) -> void:
	Settings.MasterVolume = value
	Settings.saveSettings()
	updateLabels()


func _on_sound_efects_slider_value_changed(value:float) -> void:
	Settings.SoundEffectsVolume = value
	Settings.saveSettings()
	updateLabels()


func _on_music_slider_value_changed(value:float) -> void:
	Settings.MusicVolume = value
	Settings.saveSettings()
	updateLabels()

func updateLabels() -> void:
	MusicSliderLabel.text = str(Settings.MusicVolume*100)+"%"
	SoundEffectsSliderLabel.text = str(Settings.SoundEffectsVolume*100)+"%"
	MasterSliderLabel.text = str(Settings.MasterVolume*100)+"%"