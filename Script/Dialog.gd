extends Control

@export var Icons: Dictionary[String, CompressedTexture2D]
@export_range(0.2, 2.0, 0.1) var displaySpeed: float = 0.5

@onready var peopelPanel: Panel = %PeopelPanel
@onready var peopelIcons: TextureRect = %PeopleIcons

@onready var playerPanel: Panel = %PlayerPanel
@onready var playerIcons: TextureRect = %PlayerIcons

@onready var scroll: ScrollContainer = %ScrollContainer
@onready var Text: Label = %Text

@onready var timer = $Timer

func _ready() -> void:
	Signals.peopel_message.connect(PeopleTalk)
	Signals.player_message.connect(PlayerTalk)

func PeopleTalk(iconName: String="", textToDisplay:String="") -> void:
	playerPanel.hide()
	peopelIcons.texture = Icons[iconName]
	peopelPanel.show()
	LoadinText(textToDisplay)

func PlayerTalk(iconName: String="", textToDisplay:String="") -> void:
	peopelPanel.hide()
	playerIcons.texture = Icons[iconName]
	playerPanel.show()
	LoadinText(textToDisplay)

func LoadinText(text: String):
	Text.visible_characters = 0
	Text.text = text
	for line in text.length():
		timer.start(displaySpeed)
		Text.visible_characters += 1
		scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value
		await timer.timeout
