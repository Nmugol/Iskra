extends Area2D

@export var player: Player
@export var back_to_position: Marker2D
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
			player.navigation.target_position = back_to_position.global_position
			player.sprite.play("idle")
			Signals.show_dialog.emit()
			Signals.player_message.emit("Daniel",
			exit_blocked_messages.pick_random(),
			false
			)
			
		)
