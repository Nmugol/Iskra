extends Node

@export var Icons: Dictionary[String, CompressedTexture2D]

@onready var peopelPanel: NinePatchRect = %PeopelPanel
@onready var peopelIcons: TextureRect = %PeopleIcons

@onready var playerPanel: NinePatchRect = %PlayerPanel
@onready var playerIcons: TextureRect = %PlayerIcons

@onready var scroll: ScrollContainer = %ScrollContainer
@onready var Text: RichTextLabel = %Text

@onready var timer: Timer = $Timer
@onready var closeButton: TextureButton = %CloseButton

var displaySpeed: float = 0.1
var queue: Array = []
var is_talking: bool = false
var text_is_end: bool = false
var finus_statae: bool = true
var current_text: String = ""
var current_char_index: int = 0

signal text_finished
signal talk_finished

func _ready() -> void:
	Text.bbcode_enabled = true
	finus_statae = true
	Signals.peopel_message.connect(func(icon, text): add_to_queue(PeopleTalk, icon, text))
	Signals.player_message.connect(func(icon, text): add_to_queue(PlayerTalk, icon, text))
	timer.timeout.connect(_on_timer_timeout)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Close"):
		_on_close_button_pressed()
	
	if Input.is_action_just_pressed("LoadText"):
		if !text_is_end:  # Pierwsze kliknięcie - szybkie zakończenie tekstu
			current_char_index = current_text.length()
			Text.visible_characters = current_char_index
			text_is_end = true
			timer.stop()
			text_finished.emit()
		else:  # Drugie kliknięcie - następny dialog
			talk_finished.emit()
	
	if queue.is_empty() and not is_talking:
		closeButton.show()

func add_to_queue(func_ref: Callable, iconName: String, textToDisplay: String):
	queue.append([func_ref, iconName, textToDisplay])
	process_queue()

func process_queue():
	if is_talking or queue.is_empty():
		if finus_statae:
			State.StatePhase += 1
			finus_statae = false
		return
	
	is_talking = true
	var item = queue.pop_front()
	State.StatePhase += 1
	item[0].call(item[1], item[2])

func PeopleTalk(iconName: String="", textToDisplay:String="") -> void:
	State.IsRun = false
	playerPanel.hide()
	closeButton.hide()
	peopelIcons.texture = Icons[iconName]
	peopelPanel.show()
	LoadinText(textToDisplay)
	text_finished.connect(_on_text_finished, CONNECT_ONE_SHOT)

func PlayerTalk(iconName: String="", textToDisplay:String="") -> void:
	State.IsRun = false
	peopelPanel.hide()
	closeButton.hide()
	playerIcons.texture = Icons[iconName]
	playerPanel.show()
	LoadinText(textToDisplay)
	text_finished.connect(_on_text_finished, CONNECT_ONE_SHOT)

func LoadinText(text: String) -> void:
	text_is_end = false
	Text.clear()
	Text.bbcode_text = text
	Text.visible_characters = 0
	current_text = text
	current_char_index = 0
	timer.wait_time = displaySpeed
	timer.start()

func _on_timer_timeout() -> void:
	if current_char_index < current_text.length():
		Text.visible_characters += 1
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

func _on_close_button_pressed() -> void:
	Signals.hide_dialog.emit()
	State.IsRun = true
