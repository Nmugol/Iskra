extends Area2D

@export var plyer: Player

var exit_blocked_messages: Array = [
	"Daniel cannot leave this area right now.",
	"Daniel has unfinished business here.",
	"Daniel cannot leave before completing the task.",
	"He must focus on the current situation.",
	"Leaving now is not an option."
]

func  _ready() -> void:
	self.body_entered.connect(func (body:Node2D):
		if body.is_in_group("Player"):
			plyer.nav.target_position = plyer.global_position
			plyer.sprite.play("idle")
			Signals.show_dialog.emit()
			Signals.player_message.emit("Daniel",
			exit_blocked_messages[randi()%exit_blocked_messages.size()]
			)
			State.StatePhase -= 1
		)
