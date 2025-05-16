extends Control

func _ready() -> void:
	Signals.show_ui.connect(func():show())
	show()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Mapa"):
		_on_mapa_pressed()
	
	if Input.is_action_just_pressed("Equipment"):
		_on_ekwipunek_pressed()

func _on_ekwipunek_pressed() -> void:
	Signals.show_equipment.emit()
	hide()

func _on_mapa_pressed() -> void:
	Signals.show_map.emit()
	hide()
