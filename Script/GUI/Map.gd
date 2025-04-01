extends Control

func _on_clous_button_pressed() -> void:
	State.IsRun = true
	Signals.show_ui.emit()
	hide()
