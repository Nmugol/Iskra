extends Node2D

@onready var cart_mini_game_area: Area2D = $Events/CandleMiniGame
@onready var player: Player = $Player
@onready var info_panel: InfoPanel = $CanvasLayer/InfoPanel
@onready var exit: Area2D = $Passage/Exit1
@onready var mini_game_pos: Marker2D = $Events/CandleMiniGame/Marker2D

var mini_game = load("res://Scenes/MiniGame/CandleMiniGame/candle_mini_game.tscn")

var in_candle_mini_game_area: bool = false
var mini_game_is_running: bool = false
var dialog_is_running: bool = false

var game: Node = null


func _ready():
	info_panel.is_visible_flag = false
	if State.state_number == 9:
		cart_mini_game_area.monitoring = true
		cart_mini_game_area.monitorable = true
	else:
		cart_mini_game_area.monitoring = false
		cart_mini_game_area.monitorable = false

	if State.state_number >= 12:
		Signals.change_info_panel_visibility.emit(true)

	# Automatyczne wznowienie mini-gry po powrocie do sceny
	if State.state_number == 10 and game == null:
		init_candle_mini_game()


func _process(_delta: float) -> void:
	if State.is_loading:
		return

	match State.state_number:
		9:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						_first_dialog()
						Signals.save_game.emit()
						Signals.save_to_file.emit()
		10:
			match State.state_phase:
				0:
					dialog_is_running = false
					if game == null and not dialog_is_running:
						dialog_is_running = true
						_second_dialog()
						exit.hide()
						init_candle_mini_game()
		11:
			match State.state_phase:
				0:
					dialog_is_running = false
					_finish_candle_mini_game()
					exit.show()
					Signals.show_location_button.emit(State.Locations.Shopping_Area)
					Signals.save_to_file.emit()
		12:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						_three_dialog()
					Signals.change_info_panel_visibility.emit(true)
					State.state_number = 13
					State.state_phase = 0
					Signals.save_to_file.emit()
				1:
					dialog_is_running = false
		16:
			match State.state_phase:
				0:
					exit.hide()
					if not dialog_is_running:
						dialog_is_running = true
						_four_dialog()
				1:
					dialog_is_running = false
					State.state_number = 17
					State.state_phase = 0
					Signals.save_to_file.emit()
		17:
			match State.state_phase:
				0:
					dialog_is_running = false
		18:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						_fifth_dialog()
				3:
					State.state_number = 19
					State.state_phase = 0
					Save.player_position = Vector2(856, 1584)
					Save.current_scene_path = 'res://Scenes/Locations/Mines/MineHub.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)

	if in_candle_mini_game_area and State.selected_item != null and State.selected_item.item_name == "Crystal shard" and not mini_game_is_running:
		State.state_number = 10
		State.state_phase = 0
		mini_game_is_running = true


func init_candle_mini_game() -> void:
	game = mini_game.instantiate()
	game.z_index = 1
	game.scale = Vector2(0.7, 0.7)
	game.global_position = mini_game_pos.global_position
	add_child(game)
	$PhantomCamera2D.follow_target = game
	player.hide()
	State.is_running = false


func _finish_candle_mini_game() -> void:
	var symbol_note: Item = Item.new("Symbol note", [], true, "res://Sprite/Items/SymbolNoteSmall.png", "res://Sprite/Items/SymbolNote.png", [])
	symbol_note.add_to_equipment()
	Signals.save_game.emit()
	Signals.save_to_file.emit()

	$PhantomCamera2D.follow_target = player
	mini_game_is_running = false
	State.is_running = true
	State.state_number = 12
	State.state_phase = 0

	if game != null:
		game.queue_free()
		game = null

	player.show()
	State.is_running = true
	Signals.save_game.emit()
	Signals.save_to_file.emit()


func _first_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel", "Since the mines have been closed, what should I do now? Oh, I forgot about this crystal. I can examine it calmly, but it's already late, I can barely see. Maybe the candlelight will help me see something.", true)

	#2
	Signals.player_message.emit("Daniel", "But where did I put that candle? I think I left it on the table.", true)


func _second_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel", "Oh yes, the candle! Now I can see something. What is that on the wall? Is it from this crystal? It looks like some runes, symbols...", true)
	#2
	Signals.player_message.emit("Daniel", "I wonder what it could be... Maybe I should draw it?", true)


func _three_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel", "I need to take this to Emil. He will surely know what these signs mean.", true)
	#2
	Signals.player_message.emit("Daniel", "Damn, it's already late. I need to hurry before the nighttime curfew.", true)


func _on_candle_mini_game_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_candle_mini_game_area = true


func _on_candle_mini_game_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		in_candle_mini_game_area = false


func _four_dialog() -> void:
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel", "I made it, nobody saw me.", true)
	#2
	Signals.player_message.emit("Daniel", "That was a pretty intense day. I'm exhausted. I hope tomorrow will be calmer.", true)
	Signals.player_message.emit("Daniel", "I’m going to lie down in bed and sleep.", true)
	#3
	State.day_count = 2


func _fifth_dialog() -> void:
	Signals.show_dialog.emit()
	Signals.player_message.emit("Daniel", "What time is it? It's already so late. I have to hurry, or I'll be late for the briefing.", true)
	Signals.player_message.emit("Daniel", "Wait, what's this on the table? A piece of paper? But I didn't put anything there last night.", true)
	Signals.player_message.emit("Daniel", "A map of the camp? But why is some passage marked at the railway station?", true)
	Signals.player_message.emit("Daniel", "Right, I don't have time to deal with this now. I have to go to the mine as quickly as possible.", true)


func _on_bead_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and State.state_number == 17 and State.state_phase == 2:
		Signals.play_day_screen.emit()
