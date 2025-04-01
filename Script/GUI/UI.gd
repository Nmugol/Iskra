extends Control

@onready var SettingPanel: MarginContainer = $VBoxContainer/Settings

var MenuScen: String = "res://Scenes/Menu/MainMenu.tscn"

func _ready() -> void:
	Signals.show_ui.connect(ShowUI)
	show()
	SettingPanel.hide()

func _process(delta: float) -> void:
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
		SettingPanel.show()
	else:
		State.IsRun = true
		SettingPanel.hide()


func _on_save_pressed() -> void:
	Signals.save_game.emit()
	Signals.save_to_file.emit()


func _on_exit_pressed() -> void:
	_on_save_pressed()
	get_tree().change_scene_to_file(MenuScen)
