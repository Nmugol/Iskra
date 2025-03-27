extends Node2D

@export var LevelLocation: Node
@onready var Dialog: Control = %Dialog

func _ready()->void:
	Signals.show_dialog.connect(ShowDialog)
	Signals.hide_dialog.connect(HideDialog)
	State.IsRun = true
	LoadLevel()

func LoadLevel() -> void:
	if(LevelLocation.get_child_count()>0):
		var i =LevelLocation.get_child(0)
		i.queue_free()
		
	var levelnode = load(Save.CurrentScenePath).instantiate()
	LevelLocation.add_child(levelnode)

func SaveLevel() -> void:
	Save.CurrentScenePath = LevelLocation.get_child(0).get_path()

func ShowDialog():
	Settings.IsRun = false
	Dialog.show()

func HideDialog():
	Settings.IsRun = true
	Dialog.hide()
