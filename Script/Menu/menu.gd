extends Control

var SettingsScene = "res://Scenes/Menu/settings.tscn"

func _on_quit_button_down() -> void:
	get_tree().quit()

func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file(SettingsScene)

func _on_play_button_down() -> void:
	pass
