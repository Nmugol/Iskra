extends Node2D

@onready var guard7: NPC = $Path2D/PathFollow2D/Guard5
@onready var guard8: NPC = $Path2D/PathFollow2D/Guard6
@onready var peter: NPC = $NPCS/Peter

@onready var path: PathFollow2D = $Path2D/PathFollow2D

var speed_ratio = 0.1    # prędkość w jednostkach ratio na sekundę
var target_ratio = 0.45   # gdzie ma się zatrzymać

var walk: bool = false
var dialog_is_running: bool = false

func  _ready() -> void:
	

	match State.state_number:
		0:
			match State.state_phase:
				0:
					path.progress_ratio = 0.0
					guard7.update_state("Walk", false)
					guard8.update_state("Walk", false)
		21:
			Signals.change_info_panel_text.emit("Go to the cave and find supervisor.")
			Signals.change_info_panel_visibility.emit(true)
			peter.hide()
		_:
			guard7.hide()
			guard8.hide()
			peter.hide()

func _process(delta: float) -> void:
	if State.is_loading: return
	
	if walk:
		path.progress_ratio = move_toward(path.progress_ratio, target_ratio, speed_ratio*delta)
	if abs(path.progress_ratio - target_ratio) < 0.001:
		path.progress_ratio = target_ratio
		guard7.update_state("Idle", true)
		guard8.update_state("Idle", true)
		walk = false
		
	
	match State.state_number:
		0:
			match State.state_phase:
				0: 
					if not dialog_is_running:
						dialog_is_running = true
						_first_dialog();
				4:
					guard7.update_state("Walk", false)
					guard8.update_state("Walk", false)
					walk = true
				5: 
					path.progress_ratio = target_ratio
					guard7.update_state("Idle", true)
					guard8.update_state("Idle", true)
					$NPCS/Peter.flip_sprite = false
				6:
					guard7.update_state("Walk", true)
					guard8.update_state("Walk", true)
					target_ratio = 1
					walk = true
				
				7:
					State.state_number = 1
					State.state_phase = 0
					Save.player_position = Vector2(2120.0,-40)
					Save.current_scene_path = "res://Scenes/Locations/RailwayStation/RailwayStation.tscn"
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)
		20:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						_second_dialog()
				1:
					State.state_number = 21
					State.state_phase = 0
					Signals.change_info_panel_visibility.emit(true)
					Signals.save_game.emit()
					Signals.save_to_file.emit()
		23:
			match State.state_phase:
				0:
					peter.position = Vector2(992,-104)
					show()
					_third_dialogue()
				8:
					State.state_number = 24
					State.state_phase = 0
					Signals.change_info_panel_text.emit("Meet Peter at the railway station")
					Signals.change_info_panel_visibility.emit(true)

func _first_dialog() -> void:
	Signals.show_dialog.emit()
	Signals.people_message.emit("Peter", "Hey, Daniel! You're late again. I wonder if we'll ever manage to be on time?", true)
	Signals.player_message.emit("Daniel", "Don't even get me started. On the way here, I got stopped for a check. They thought I was carrying contraband. And you know how long their personal searches take.", true)
	Signals.people_message.emit("Peter", "The guards are especially active today and aren't letting anyone off easy. This morning they searched me too, and now I'm super stressed. You know I don't want any trouble with the authorities.", true)
	Signals.player_message.emit("Daniel", "I know you don't want any trouble, and you want to do everything you can to increase your chances of transferring camps. But did you hear? The resistance gave them a hard time again. They scattered posters around the camp calling for a rebellion. And apparently, they also stole some of the guards' uniforms.",true)
	Signals.people_message.emit("Guard7", "Daniel and Peter, you're coming with us. One of the loaded wagons derailed and is blocking the loading of the others. You have been chosen to help clear the tracks.",true)
	Signals.people_message.emit("Peter", "[shake rate=15.0 level=2 connecter=1]Whaaa...? Whyyy usss?[/shake]",true)
	Signals.people_message.emit("Guard8", "Your Sparks will come in handy for removing the wagon. Don't waste our time and move it.",true)
	Signals.player_message.emit("Daniel", "Alright, we're coming. Peter, calm down and don't panic.", true)

func _second_dialog() -> void:
	Signals.show_dialog.emit()
	Signals.player_message.emit("Daniel", "There's no one here anymore. The supervisor probably took everyone to the mine.", true)
	Signals.player_message.emit("Daniel", "I'll have to stay after hours again to make up for the delay.", true)

func _third_dialogue() -> void:
	Signals.show_dialog.emit()
	Signals.people_message.emit("Peter", "Oh, Daniel, hey. Have you finished your shift for today?", true)
	Signals.player_message.emit("Daniel", "Yeah, about 30 minutes ago.", true)
	Signals.people_message.emit("Peter", "Will you help me with one thing?", true)
	Signals.player_message.emit("Daniel", "Sure, but with what?", true)
	Signals.people_message.emit("Peter", "Let's meet at the train station.", true)
	Signals.player_message.emit("Daniel", "What did you do again? I don't really like this, but I'll help you.", true)
	Signals.people_message.emit("Peter", "Oh, don't worry, I'm not up to anything.", true)
	Signals.people_message.emit("Peter", "Let's meet there and I'll explain everything to you.", true)
