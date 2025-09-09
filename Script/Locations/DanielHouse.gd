extends Node2D

@onready var cart_mini_game_area: Area2D = $Events/CandleMiniGame
@onready var player: Player = $Player
@onready var info_panel: InfoPanel = $CanvasLayer/InfoPanel
@onready var exit: Area2D = $Passage/Exit1

var mini_game = load("res://Scenes/MiniGame/CandleMiniGame/candle_mini_game.tscn")

var in_candle_mini_game_area: bool = false
var mini_game_is_running: bool = false


func _ready():
	info_panel.is_visible_flag = false
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
					Signals.save_to_file.emit()
					_second_dialog()
					exit.monitoring = false
					exit.monitorable = false
					init_candle_mini_game()


		11:
			match State.state_phase:
				0:
					_finish_candle_mini_game()
					exit.monitoring = true
					exit.monitorable = true
		12:
			match State.state_phase:
				0:
					_three_dialog()
					info_panel.is_visible_flag = true
					State.state_number = 13
					State.state_phase = 0
					Signals.save_to_file.emit()
	

	if in_candle_mini_game_area and State.selected_item != null and State.selected_item.item_name == "Crystal shard" and not mini_game_is_running:
		State.state_number = 10
		State.state_phase = 0
		mini_game_is_running = true

func init_candle_mini_game() -> void:
	var game = mini_game.instantiate()
	game.z_index = 1
	game.global_position = $PhantomCamera2D.global_position
	add_child(game)
	$PhantomCamera2D.follow_target = game
	$PhantomCamera2D.zoom = Vector2(1.4, 1.4)
	player.hide()
	State.is_running = false


func _finish_candle_mini_game() -> void:
	$PhantomCamera2D.follow_target = player
	$PhantomCamera2D.zoom = Vector2(3, 3)
	State.state_number = 12
	State.state_phase = 0
	mini_game_is_running = false
	State.is_running = true


	player.show()
	State.is_running = true

func _first_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel","Since the mines have been closed, what should I do now? Oh, I forgot about this crystal. I can examine it calmly, but it's already late, I can barely see. Maybe the candlelight will help me see something.")

	#2
	Signals.player_message.emit("Daniel","But where did I put that candle? I think I left it on the table.")

func _second_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel","Oh yes, the candle! Now I can see something. What is that on the wall? Is it from this crystal? It looks like some runes, symbols...")
	#2
	Signals.player_message.emit("Daniel","I wonder what it could be... Maybe I should draw it?")

func _three_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel","I need to take this to Emil. He will surely know what these signs mean.")
	#2
	Signals.player_message.emit("Daniel","Damn, it's already late. I need to hurry before the nighttime curfew.")

func _on_candle_mini_game_body_entered(body:Node2D) -> void:
	if body.is_in_group("Player"):
		in_candle_mini_game_area = true


func _on_candle_mini_game_body_exited(body:Node2D) -> void:
	if body.is_in_group("Player"):
		in_candle_mini_game_area = false
