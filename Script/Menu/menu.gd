extends Control

# Scena z ustawieniami
var SettingsScene = "res://Scenes/Menu/settings.tscn"

# Funkcja obsługująca wyłączenie gry
func _on_quit_button_down() -> void:
	get_tree().quit()

# Funkcja obsługująca przeładowanie sceny na scenę z ustawieniami
func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file(SettingsScene)

# Funkcja obsługująca przeładowanie sceny na scenę gry
func _on_play_button_down() -> void:
	pass # Replace with function body.
