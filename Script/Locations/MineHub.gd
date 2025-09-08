extends Node2D

@onready var player: Player = $Player

@export var guard7:NPC

const  MAIN_SCENE = "res://Scenes/World.tscn"


func _process(_delta: float) -> void:
	if State.is_loading: return
	match State.state_number:
		8:
			match State.state_phase:
				0:
					guard7.show()
					_first_dialog()
				3:
					State.state_number = 9
					State.state_phase = 0
					Save.player_position = Vector2(704,-424) 
					Save.current_scene_path = 'res://Scenes/Locations/Town/DanielHouse.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(MAIN_SCENE)


func _first_dialog() -> void:
	player.sprite.play("idle")
	Signals.show_dialog.emit()
	#1
	Signals.people_message.emit("Guard7", "Daniel, go home. There’s been a gas leak in the mine. Your section has been closed until further notice. You’ll receive a new assignment tomorrow.")
	
	#1
	Signals.player_message.emit("Daniel", "Wait, what?!... Is everyone okay?")

	#2
	Signals.people_message.emit("Guard7", "No one was hurt. Everyone is safe. Take my advice and go home. Now. Understood.")

	#3
	Signals.player_message.emit("Daniel", "Phew... Alright, I’m going.")
	
