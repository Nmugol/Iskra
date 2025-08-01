extends Area2D

@export var plyer: Player

@export var active_on: Array[int] = []

var exit_blocked_messages: Array = [
	"Daniel cannot leave this area right now.",
	"Daniel has unfinished business here.",
	"Daniel cannot leave before completing the task.",
	"He must focus on the current situation.",
	"Leaving now is not an option."
]

func  _ready() -> void:
	
	if State.state_number not in active_on:
		self.queue_free()
	
	self.body_entered.connect(func (body:Node2D):
		if body.is_in_group("Player"):
			var pos: Vector2 = plyer.global_position
			plyer.navigation.target_position = pos
			plyer.sprite.play("idle")
			Signals.show_dialog.emit()
			Signals.player_message.emit("Daniel",
			exit_blocked_messages[randi()%exit_blocked_messages.size()-1]
			)
			State.StatePhase -= 1
		)
