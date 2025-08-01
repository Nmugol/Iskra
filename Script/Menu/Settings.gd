extends Control

var MainScene = "res://Scenes/Menu/MainMenu.tscn"
@export_group("Window Settings")
@export var resolution_button: OptionButton
@export var window_type_button: OptionButton

@export_group("Audio Settings")
@export var master_slider: HSlider
@export var master_slider_label: Label

@export var music_slider: HSlider
@export var music_slider_label: Label

@export var sound_effects_slider: HSlider
@export var sound_effects_slider_label: Label

func _ready() -> void:
	set_up()

func set_up() -> void:
	for resolution in Settings.screen_resolution_options:
		resolution_button.add_item(resolution)	
	resolution_button.selected = Settings.resolution_index

	for windowType in Settings.window_type_options:
		window_type_button.add_item(windowType)
	window_type_button.selected = Settings.window_type

	master_slider.value = Settings.master_volume
	music_slider.value = Settings.music_volume
	sound_effects_slider.value = Settings.sound_effects_volume

	updateLabels()

func _on_resolution_button_item_selected(index:int) -> void:
	Settings.resolution_index = index
	var res = Settings.screen_resolution_options[index].split("x")
	Settings.screen_resolution = Vector2(int(res[0]), int(res[1]))
	
	Settings.save_settings()

func _on_window_type_button_item_selected(index:int) -> void:
	Settings.window_type = index
	
	Settings.save_settings()


func _on_mian_menu_button_down() -> void:
	get_tree().change_scene_to_file(MainScene)


func _on_reset_button_down() -> void:
	Settings.resetSettings()
	resolution_button.selected = 0
	window_type_button.selected = 0

	master_slider.value = 1
	music_slider.value = 1
	sound_effects_slider.value = 1

func _on_master_slider_value_changed(value:float) -> void:
	Settings.master_volume = value
	Settings.save_settings()
	updateLabels()


func _on_sound_effects_slider_value_changed(value:float) -> void:
	Settings.sound_effects_volume = value
	Settings.save_settings()
	updateLabels()


func _on_music_slider_value_changed(value:float) -> void:
	Settings.music_volume = value
	Settings.save_settings()
	updateLabels()

func updateLabels() -> void:
	music_slider_label.text = str(Settings.music_volume*100)+"%"
	sound_effects_slider_label.text = str(Settings.sound_effects_volume*100)+"%"
	master_slider_label.text = str(Settings.master_volume*100)+"%"


func _on_button_button_down() -> void:
	Signals.delete_save.emit()


func _on_sound_effects_slider_changed() -> void:
	pass # Replace with function body.
