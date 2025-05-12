extends Node

@export var Icons: Dictionary[String, CompressedTexture2D]

@onready var peopelPanel: Panel = %PeopelPanel
@onready var peopelIcons: TextureRect = %PeopleIcons

@onready var playerPanel: Panel = %PlayerPanel
@onready var playerIcons: TextureRect = %PlayerIcons

@onready var scroll: ScrollContainer = %ScrollContainer
# Zmieniliśmy Label na RichTextLabel
@onready var Text: RichTextLabel = %Text

@onready var timer: Timer = $Timer
@onready var closeButton: Button = %CloseButton

var displaySpeed: float = 0.1
var queue: Array = []
var is_talking: bool = false
var next: bool = false
var text_is_end: bool = false

func _ready() -> void:
	# Włączamy BBCode (jeśli chcemy później używać tagów)
	Text.bbcode_enabled = true
	Signals.peopel_message.connect(func(icon, text): add_to_queue(PeopleTalk, icon, text))
	Signals.player_message.connect(func(icon, text): add_to_queue(PlayerTalk, icon, text))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("LoadText"):
		displaySpeed = 0.01
	if Input.is_action_just_pressed("NextText") and text_is_end:
		next = true
	if queue.is_empty() and not is_talking:
		closeButton.show()

func add_to_queue(func_ref: Callable, iconName: String, textToDisplay: String):
	queue.append([func_ref, iconName, textToDisplay])
	process_queue()

func process_queue():
	if is_talking or queue.is_empty():
		return
	
	is_talking = true
	var item = queue.pop_front()
	var func_ref = item[0]
	var iconName = item[1]
	var textToDisplay = item[2]
	await func_ref.call(iconName, textToDisplay)
	
	next = false
	while not next:
		await get_tree().process_frame

	is_talking = false
	process_queue() 

func PeopleTalk(iconName: String="", textToDisplay:String="") -> void:
	State.IsRun = false
	playerPanel.hide()
	closeButton.hide()
	peopelIcons.texture = Icons[iconName]
	peopelPanel.show()
	await LoadinText(textToDisplay)
	

func PlayerTalk(iconName: String="", textToDisplay:String="") -> void:
	State.IsRun = false
	peopelPanel.hide()
	closeButton.hide()
	playerIcons.texture = Icons[iconName]
	playerPanel.show()
	await LoadinText(textToDisplay)
	

func LoadinText(text: String) -> void:
	text_is_end = false
	displaySpeed = 0.1
	Text.clear()                    # czyścimy zawartość
	Text.bbcode_text = text         # ustawiamy pełny tekst
	Text.visible_characters = 0     # żadnych widocznych znaków na start
	for i in text.length():
		timer.start(displaySpeed)
		Text.visible_characters += 1
		# przewiń na sam dół
		scroll.scroll_vertical = floor(scroll.get_v_scroll_bar().max_value)
		await timer.timeout
	text_is_end = true

func _on_close_button_pressed() -> void:
	Signals.hide_dialog.emit()
	State.IsRun = true
