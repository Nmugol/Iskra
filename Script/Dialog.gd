extends Control

@export_category("Player")
@export var playerbox: MarginContainer
@export var playericon: TextureRect
@export var playertext: Label
@export var playericonslist: Array[CompressedTexture2D]

@export_category("People")
@export var peoplebox: MarginContainer
@export var peopleicon: TextureRect
@export var peopletext: Label
@export var peopleiconslist: Array[CompressedTexture2D]


func _ready() -> void:
	Signals.peopel_message.connect(PeopleTalk)
	Signals.player_message.connect(PlayerTalk)
	InitBox()
	
func PeopleTalk(iconNr: int=0, text: String="") -> void:
	peoplebox.hide()
	peoplebox.show()
	peopleicon.texture = peopleiconslist[iconNr]
	peopletext.text = text
	
func PlayerTalk(iconNr: int=0, text: String="") -> void:
	peoplebox.hide()
	playerbox.show()
	playericon.texture = playericonslist[iconNr]
	playertext.text = text
	
func InitBox() -> void:
	playerbox.hide()
	playericon.texture = playericonslist[0]
	playertext.text = ""
	
	peoplebox.hide()
	peopleicon.texture = peopleiconslist[0]
	peopletext.text = ""
