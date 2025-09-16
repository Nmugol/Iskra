extends Node2D

@export var level_location: Node

@onready var dialog: Control = %Dialog
@onready var equipment: Control = %Equipment
@onready var map: Control = %Map
@onready var transition: AnimationPlayer = %Transition
@onready var settings_in_game: Control = %Setting
@onready var contro_button: Control = %UI

func _ready() -> void:

	transition.play("loading")
	_connect_signals()
	load_level()
	await transition.animation_finished


func _connect_signals() -> void:
	Signals.show_ui.connect(func(): settings_in_game.show())
	
	Signals.show_dialog.connect(_show_dialog)
	Signals.hide_dialog.connect(hide_dialog)
	
	Signals.show_equipment.connect(show_equipment)
	Signals.hide_equipment.connect(hide_equipment)
	
	Signals.show_map.connect(show_map)
	Signals.hide_map.connect(hide_map)
	
	Signals.change_scene.connect(load_level)
	Signals.disable_loading_screen.connect(disable_loading_screen)
	Signals.enable_loading_screen.connect(enable_loading_screen)
	
	Signals.show_settings_in_game.connect(show_setting_in_game)
	Signals.hide_settings_in_game.connect(hide_setting_in_game)
	
func load_level() -> void:
	State.is_running = false
	State.is_loading = true
	# Usunięcie czelniejszych zładowanych scen
	for l in level_location.get_children():
		l.queue_free()
	
	# Załadowanie poziomu
	var level_node = load(Save.current_scene_path).instantiate()
	level_location.add_child(level_node)
	disable_loading_screen()
	Signals.save_game.emit()
	Signals.save_to_file.emit()

func save_level() -> void:
	Save.current_scene_path = level_location.get_child(0).get_path()

func _show_dialog() -> void:
	Signals.reset_cursor.emit()
	State.is_running = false
	dialog.show()
	hide_equipment()
	hide_setting_in_game()
	hide_map()
	contro_button.hide()

func hide_dialog() -> void:
	State.is_running = true
	dialog.hide()
	contro_button.show()
	settings_in_game.show()

func show_equipment() -> void:
	State.is_running = false
	Signals.reset_cursor.emit()
	
	equipment.show()
	hide_dialog()
	hide_map()
	hide_setting_in_game()

func hide_equipment() -> void:
	State.is_running = true
	equipment.hide()

func show_map() -> void:
	Signals.reset_cursor.emit()
	State.is_running = false
	map.show()
	hide_dialog()
	hide_equipment()
	hide_setting_in_game()

func hide_map() -> void:
	State.is_running = true
	map.hide()

func disable_loading_screen() -> void:
	transition.play("fade_in")
	hide_dialog()
	hide_equipment()
	hide_map()
	Signals.show_ui.emit()
	await transition.animation_finished
	await get_tree().create_timer(0.2).timeout
	State.is_loading = false
	State.is_running = true

func enable_loading_screen() -> void:
	transition.play("fade_out")
	await transition.animation_finished

func show_setting_in_game() -> void:
	hide_dialog()
	hide_equipment()
	hide_map()
	settings_in_game.show()

func hide_setting_in_game() -> void:
	settings_in_game.hide()
	
