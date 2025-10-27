extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Close") and visible:
		_on_close_button_pressed()


func _on_close_button_pressed() -> void:
	State.is_running = true
	Signals.show_ui.emit()
	hide()
