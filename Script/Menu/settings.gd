extends Control

var MainScene = "res://Scenes/Menu/main_menu.tscn"

func _on_back_to_mani_menu_button_down() -> void:
	get_tree().change_scene_to_file(MainScene)
