extends Control

var MenuScen: String = "res://Scenes/Menu/MainMenu.tscn"

func _on_save_pressed() -> void:
	Signals.save_game.emit()
	Signals.save_to_file.emit()
	
func _on_exit_pressed() -> void:
	_on_save_pressed()
	get_tree().change_scene_to_file(MenuScen)


func _on_panel_mouse_entered() -> void:
	State.IsRun = false


func _on_panel_mouse_exited() -> void:
	State.IsRun = true
