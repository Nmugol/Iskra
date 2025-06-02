extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Close") and visible:
		_on_clous_button_pressed()

func _on_clous_button_pressed() -> void:
	State.IsRun = true
	Signals.show_ui.emit()
	hide()
