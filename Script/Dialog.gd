extends Node

@export var Icons: Dictionary[String, CompressedTexture2D]

@onready var peopelPanel: Panel = %PeopelPanel
@onready var peopelIcons: TextureRect = %PeopleIcons

@onready var playerPanel: Panel = %PlayerPanel
@onready var playerIcons: TextureRect = %PlayerIcons

@onready var scroll: ScrollContainer = %ScrollContainer
@onready var Text: Label = %Text

@onready var timer: Timer = $Timer
@onready var closeButton: Button = %CloseButton

var displaySpeed: float = 0.5
var queue: Array = []
var is_talking: bool = false

func _ready() -> void:
	Signals.peopel_message.connect(func(icon, text): add_to_queue(PeopleTalk, icon, text))
	Signals.player_message.connect(func(icon, text): add_to_queue(PlayerTalk, icon, text))


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("LoadText"): displaySpeed= 0.01
	if queue.is_empty() and not is_talking: closeButton.show()

func add_to_queue(func_ref: Callable, iconName: String, textToDisplay: String):
	queue.append([func_ref, iconName, textToDisplay])
	process_queue()

func process_queue():
	if is_talking or queue.is_empty(): return
	
	is_talking = true
	var item = queue.pop_front()
	var func_ref = item[0]
	var iconName = item[1]
	var textToDisplay = item[2]
	await func_ref.call(iconName, textToDisplay)
	is_talking = false
	process_queue() 

func PeopleTalk(iconName: String="", textToDisplay:String="") -> void:
	playerPanel.hide()
	closeButton.hide()
	peopelIcons.texture = Icons[iconName]
	peopelPanel.show()
	await LoadinText(textToDisplay)

func PlayerTalk(iconName: String="", textToDisplay:String="") -> void:
	peopelPanel.hide()
	closeButton.hide()
	playerIcons.texture = Icons[iconName]
	playerPanel.show()
	await LoadinText(textToDisplay)

func LoadinText(text: String):
	displaySpeed = 0.5
	Text.visible_characters = 0
	Text.text = text
	for line in text.length():
		timer.start(displaySpeed)
		Text.visible_characters += 1
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value
		await timer.timeout


func _on_close_button_pressed() -> void:
	Signals.hide_dialog.emit()
