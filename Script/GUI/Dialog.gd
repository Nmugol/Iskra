extends Node

@export var icons: Dictionary[String, CompressedTexture2D]

@onready var people_panel: NinePatchRect = %PeoplePanel
@onready var people_icons: TextureRect = %PeopleIcons

@onready var player_panel: NinePatchRect = %PlayerPanel
@onready var player_icons: TextureRect = %PlayerIcons

@onready var scroll: ScrollContainer = %ScrollContainer
@onready var text_to_display: RichTextLabel = %Text

@onready var timer: Timer = $Timer
@onready var close_button: TextureButton = %CloseButton

var display_speed: float = 0.1
var queue: Array = []
var is_talking: bool = false
var text_is_end: bool = false
var finish_state: bool = true
var current_text: String = ""
var current_char_index: int = 0

signal text_finished
signal talk_finished

func _ready() -> void:
	text_to_display.bbcode_enabled = true
	finish_state = true
	Signals.people_message.connect(func(icon, text): add_to_queue(people_talk, icon, text))
	Signals.player_message.connect(func(icon, text): add_to_queue(player_talk, icon, text))
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Close"):
		_on_close_button_pressed()
	
	if Input.is_action_just_pressed("LoadText"):
		if !text_is_end:  # Pierwsze kliknięcie - szybkie zakończenie tekstu
			current_char_index = current_text.length()
			text_to_display.visible_characters = current_char_index
			text_is_end = true
			timer.stop()
			text_finished.emit()
		else:  # Drugie kliknięcie - następny dialog
			talk_finished.emit()
	
	if queue.is_empty() and not is_talking:
		close_button.show()

func add_to_queue(func_ref: Callable, iconName: String, textToDisplay: String):
	queue.append([func_ref, iconName, textToDisplay])
	process_queue()

func process_queue():
	if is_talking or queue.is_empty():
		if finish_state:
			State.state_phase += 1
			finish_state = false
		return
	
	is_talking = true
	var item = queue.pop_front()
	State.state_phase += 1
	item[0].call(item[1], item[2])

func people_talk(iconName: String="", textToDisplay:String="") -> void:
	State.is_running = false
	player_panel.hide()
	close_button.hide()
	people_icons.texture = icons[iconName]
	people_panel.show()
	loading_text(textToDisplay)
	text_finished.connect(_on_text_finished, CONNECT_ONE_SHOT)

func player_talk(iconName: String="", textToDisplay:String="") -> void:
	State.is_running = false
	people_panel.hide()
	close_button.hide()
	player_icons.texture = icons[iconName]
	player_panel.show()
	loading_text(textToDisplay)
	text_finished.connect(_on_text_finished, CONNECT_ONE_SHOT)

func loading_text(text: String) -> void:
	text_is_end = false
	text_to_display.clear()
	text_to_display.bbcode_text = text
	text_to_display.visible_characters = 0
	current_text = text
	current_char_index = 0
	timer.wait_time = display_speed
	timer.start()

func _on_timer_timeout() -> void:
	if current_char_index < current_text.length():
		text_to_display.visible_characters += 1
		current_char_index += 1
		scroll.scroll_vertical = floor(scroll.get_v_scroll_bar().max_value)
		timer.start()
	else:
		text_is_end = true
		text_finished.emit()

func _on_text_finished():
	# Czekaj na drugie kliknięcie LoadText
	await self.talk_finished
	is_talking = false
	process_queue()
	
	# Dodane: pokaż przycisk zamknięcia, jeśli nie ma już dialogów
	if queue.is_empty():
		close_button.show()

func _on_close_button_pressed() -> void:
	Signals.hide_dialog.emit()
	State.is_running = true
