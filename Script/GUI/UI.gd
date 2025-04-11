extends Control

func _ready() -> void:
	Signals.show_ui.connect(ShowUI)
	show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Mapa"):
		_on_mapa_pressed()
	
	if Input.is_action_just_pressed("Equipment"):
		_on_ekwipunek_pressed()
	
	if Input.is_action_just_pressed("Settings"):
		_on_ustawienia_pressed()

func _on_ekwipunek_pressed() -> void:
	Signals.show_equipment.emit()
	hide()

func _on_mapa_pressed() -> void:
	Signals.show_map.emit()
	hide()

func ShowUI() -> void:
	show()

func _on_ustawienia_pressed() -> void:
	if State.IsRun:
		State.IsRun = false
		Signals.show_settin_in_game.emit()
	else:
		State.IsRun = true
		Signals.hide_settin_in_game.emit()
