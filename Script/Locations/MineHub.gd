extends Node2D

@onready var player: Player = $Player
const  MainScene = "res://Scenes/World.tscn"


func _process(_delta: float) -> void:
	match State.StateNumber:
		8:
			match State.StatePhase:
				0:
					_first_dialog()

func _first_dialog() -> void:
	player.sprite.play("idle")
	Signals.show_dialog.emit()
	#1
	Signals.peopel_message.emit("Guard7",
	"
	Daniel, go home. There’s been a gas leak in the mine.
	Your section has been closed until further notice.
	You’ll receive a new assignment tomorrow.
	")
	
	#1
	Signals.player_message.emit("Daniel",
	"
	Wait, what?!...
	Is everyone okay?
	")

	#2
	Signals.peopel_message.emit("Guard7",
	"
	No one was hurt. Everyone is safe.
	Take my advice and go home. Now.
	Understood.
	")

	#3
	Signals.player_message.emit("Daniel",
	"
	Phew...
	Alright, I’m going.
	")
	
