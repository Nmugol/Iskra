extends Control

var windows_is_open: bool = false

func _ready() -> void:
	Signals.show_ui.connect(func():show())
	show()

func _process(_delta: float) -> void:
	
	if Input.is_action_just_pressed("Mapa") and self.visible:
		_on_mapa_pressed()
	
	if Input.is_action_just_pressed("Equipment") and self.visible: 
		_on_ekwipunek_pressed()

func _on_ekwipunek_pressed() -> void:
	Signals.show_equipment.emit()
	hide()

func _on_mapa_pressed() -> void:
	Signals.show_map.emit()
	hide()

func _on_mouse_entered() -> void:
	State.is_running = false


func _on_mouse_exited() -> void:
	State.is_running = true
