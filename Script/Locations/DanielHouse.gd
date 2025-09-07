extends Node2D

@onready var mini_game_position: Marker2D = $Events/CandleMiniGame/Marker2D
@onready var cart_mini_game_area: Area2D = $Events/CandleMiniGame
@onready var player: Player = $Player

var mini_game = load("res://Scenes/MiniGame/CandleMiniGame/candle_mini_game.tscn")

var in_candle_mini_game_area: bool = false



func _ready():

	if State.state_number == 9:
		cart_mini_game_area.monitoring = true
		cart_mini_game_area.monitorable = true
	else:
		cart_mini_game_area.monitoring = false
		cart_mini_game_area.monitorable = false
		

func _process(_delta: float) -> void:
	if State.is_loading: return

	match State.state_number:
		9:
			match State.state_phase:
				0:
					_first_dialog()
				
		
		10:
			match State.state_phase:
				0:
					init_candle_mini_game()
					_second_dialog()
				3:
					_finish_candle_mini_game()
		11:
			match State.state_phase:
				0:
					_three_dialog()
					State.state_number = 12
					State.state_phase = 0
	

	if in_candle_mini_game_area and State.selected_item.item_name == "Crystal shard" and State.selected_item != null:
		init_candle_mini_game()
		State.state_number = 10
		State.state_phase = 0

func init_candle_mini_game() -> void:
	var game = mini_game.instantiate()
	game.z_index = 1
	game.global_position = mini_game_position.global_position
	add_child(game)
	$PhantomCamera2D.follow_target = game
	player.hide()
	State.is_running = false


func _finish_candle_mini_game() -> void:
	$PhantomCamera2D.follow_target = player
	State.state_number = 11
	State.state_phase = 0

	player.show()
	State.is_running = true

func _first_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.people_message.emit("Daniel","Skoro kopalnie zostały zamknięte co mam teraz zrobić? Oj zapomniałem o tym krysztale, mogę go na spokojnie obejrzeć ale jest już późno, ledwie co widzę. Może światło świecy pomoże mi coś zobaczyć.")

	#2
	Signals.player_message.emit("Daniel","Tylko gdzie ja odłożyłem tą świecę? Chyba odłożyłem ją na stół.")
	

func _second_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.people_message.emit("Daniel","O tak, świeca! Teraz mogę coś zobaczyć. Co to jest na tej scianie? Czy to z tego kryształu? Wyglada jak jakieś runy, symbole...")
	#2
	Signals.player_message.emit("Daniel","Ciekawe co to może być... Może powinienem to narysować?")
	State.state_phase = 1

func _three_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.people_message.emit("Daniel","Muszę to zanieść do Emila, on na pewno będzie wiedział co to znaki.")

	#2
	Signals.player_message.emit("Daniel","Cholera, jest już późno, muszę się śpieszyć zanim będzie cisza nocna.")

func _on_candle_mini_game_body_entered(body:Node2D) -> void:
	if body.is_in_group("Player"):
		in_candle_mini_game_area = true


func _on_candle_mini_game_body_exited(body:Node2D) -> void:
	if body.is_in_group("Player"):
		in_candle_mini_game_area = false
