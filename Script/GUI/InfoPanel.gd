extends Control

class_name InfoPanel

@onready var panel: NinePatchRect = $NinePatchRect
@onready var info_text: RichTextLabel = $NinePatchRect/MarginContainer/RichTextLabel
@onready var button: TextureButton = $NinePatchRect/TextureButton

@export_category("Panel size")
@export_range(55, 1000, 5) var width: float = 300.0
@export_range(55, 1000, 5) var height: float = 150.0

@export_category("Text")
@export var text_to_display: String = "Info text"

@export_category("Visibility")
@export var is_visible_flag: bool = false
@export var active_on_stages: Array[int]

@export_category("Audio")
@export var button_sfx: AudioStream

const MINIMAL_SIZE: Vector2 = Vector2(60, 53)

var is_in_minimal_size: bool = false
var ui_blocker_count: int = 0


func _ready() -> void:
	panel.size = Vector2(width, height)
	info_text.text = text_to_display

	_connect_signals()
	change_visibility()


func _connect_signals() -> void:
	# Sygnały do włączania/wyłączania "aktywności" panelu
	Signals.change_info_panel_visibility.connect(_on_change_info_panel_visibility)
	Signals.change_info_panel_text.connect(change_text)

	# Sygnały pokazujące UI, które blokują panel (wg. WorldControler.gd)
	Signals.show_map.connect(_on_show_ui_blocker)
	Signals.show_equipment.connect(_on_show_ui_blocker)
	Signals.show_dialog.connect(_on_show_ui_blocker)
	Signals.show_settings_in_game.connect(_on_show_ui_blocker)

	# Sygnały ukrywające UI, które odblokowują panel
	Signals.hide_map.connect(_on_hide_ui_blocker)
	Signals.hide_equipment.connect(_on_hide_ui_blocker)
	Signals.hide_dialog.connect(_on_hide_ui_blocker)
	Signals.hide_settings_in_game.connect(_on_hide_ui_blocker)

	# Sygnały od dialogu (nadal przydatne)
	Signals.show_dialog.connect(func() -> void: set_process_input(false))
	Signals.hide_dialog.connect(func() -> void: set_process_input(true))


func _on_change_info_panel_visibility(is_active: bool) -> void:
	is_visible_flag = is_active
	change_visibility()


func _on_show_ui_blocker() -> void:
	ui_blocker_count += 1
	change_visibility()


func _on_hide_ui_blocker() -> void:
	ui_blocker_count = max(0, ui_blocker_count - 1)
	change_visibility()


func change_text(new_text: String) -> void:
	text_to_display = new_text
	panel.size = Vector2(width, height)
	is_in_minimal_size = false
	info_text.text = text_to_display
	info_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT


func change_visibility() -> void:
	var should_be_active = is_visible_flag and active_on_stages.has(State.state_number)
	if should_be_active and ui_blocker_count == 0:
		show()
	else:
		hide()


func _on_texture_button_pressed() -> void:
	if is_in_minimal_size:
		panel.size = Vector2(width, height)
		is_in_minimal_size = false
		info_text.text = text_to_display
		info_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	else:
		panel.size = MINIMAL_SIZE
		is_in_minimal_size = true
		info_text.text = ""
		info_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	Signals.play_sound.emit(State.AudioType.Effect, button_sfx, 1, -15)
	button.release_focus()
