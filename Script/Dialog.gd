extends Control

@export_category("tetx setings")
@export var speed: float = 1.0

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
	
	PeopleTalk(0,["okwdad","2edadwadawd"])

func PeopleTalk(iconNr: int=0, text: Array[String]=[""]) -> void:
	playerbox.hide()
	peoplebox.show()
	peopleicon.texture = peopleiconslist[iconNr]
	peopleicon.show()
	LoadinText(peopletext,text)

func PlayerTalk(iconNr: int=0, text: Array[String]=[""]) -> void:
	peoplebox.hide()
	playerbox.show()
	playericon.texture = playericonslist[iconNr]
	playericon.show()
	LoadinText(playertext,text)

func InitBox() -> void:
	playerbox.hide()
	playericon.texture = playericonslist[0]
	playertext.text = ""
	
	peoplebox.hide()
	peopleicon.texture = peopleiconslist[0]
	peopletext.text = ""

func LoadinText(TetxContainer: Label, text: Array[String]):
	TetxContainer.text = ""
	for line in text:
		TetxContainer.text += line +"\n"
		if not Input.is_action_just_pressed("LoadText"):
			await get_tree().create_timer(speed).timeout
