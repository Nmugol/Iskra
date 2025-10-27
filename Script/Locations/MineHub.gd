extends Node2D

@onready var player: Player = $Player
@export var guard7: NPC

var dialog_is_running: bool = false


func _ready() -> void:
	match State.state_number:
		8:
			match State.state_phase:
				0:
					guard7.position = Vector2(760, 1640)
					guard7.show()
		19:
			match State.state_phase:
				0:
					guard7.position = Vector2(704, 1584)
					guard7.show()


func _process(_delta: float) -> void:
	if State.is_loading:
		return
	match State.state_number:
		8:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						_first_dialog()
				3:
					dialog_is_running = false
					State.state_number = 9
					State.state_phase = 0
					Save.player_position = Vector2(704, -424)
					Save.current_scene_path = 'res://Scenes/Locations/Town/DanielHouse.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)
		19:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						_second_dialog()
				5:
					State.state_number = 20
					State.state_phase = 0
					Save.player_position = Vector2(1064, -88)
					Save.current_scene_path = 'res://Scenes/Locations/Mines/Mines.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)


func _first_dialog() -> void:
	player.sprite.play("idle")
	Signals.show_dialog.emit()
	#0
	Signals.people_message.emit("Guard7", "Daniel, go home. There’s been a gas leak in the mine. Your section has been closed until further notice. You’ll receive a new assignment tomorrow.", true)
	#1
	Signals.player_message.emit("Daniel", "Wait, what?!... Is everyone okay?", true)
	#2
	Signals.people_message.emit("Guard7", "No one was hurt. Everyone is safe. Take my advice and go home. Now. Understood.", true)
	#3
	Signals.player_message.emit("Daniel", "Phew... Alright, I’m going.", true)


func _second_dialog() -> void:
	Signals.show_dialog.emit()
	Signals.people_message.emit("Guard7", "Daniel, you're late again.", true)
	Signals.player_message.emit("Daniel", "I'm sorry, but after...", true)
	Signals.people_message.emit("Guard7", "Don't give me excuses, just get moving to the first mine. You have the task of clearing the tunnel.", true)
	Signals.player_message.emit("Daniel", "Sure, I'm going. Wait, what? What tunnel?", true)
	Signals.people_message.emit("Guard7", "After yesterday's leak, one of the tunnels collapsed, and it needs to be restored to operation as soon as possible.", true)
	Signals.people_message.emit("Guard7", "Move it, get going! The rest of the crew is already waiting for you there.", true)
