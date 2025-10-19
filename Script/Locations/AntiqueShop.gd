extends Node2D

@export var player: Player

@export_category("Mini game")
@export var mini_game_position: Marker2D

@export_category("NPC")
@export var emil: NPC
@export var miriam: NPC

@export_category("NPC path")
@export var miriam_path: PathController
@export var emil_path: PathController

@export_category("Exit")
@export var exit_1: Area2D
@export var exit_2: Area2D

@export_category("State 13")
@export var player_pos: Vector2


var game: Node = null
var mini_game = load("res://Scenes/MiniGame/PatrolMiniGame/patrol_mini_game.tscn")

var dialog_is_running: bool = false


func _ready() -> void:

	

	Signals.finish_patrol_game.connect(finish_patrol_mini_game)

	if State.state_number == 13:
		
		emil.show()
		miriam.show()

		player.navigation.target_position = player_pos
		player.global_position = player_pos
		player.position = player_pos

		exit_1.hide()        
		exit_2.hide()

	if State.state_number == 14:
		emil.show()

		exit_1.monitorable = false
		exit_1.monitoring = false
		exit_2.monitorable = false        
		exit_2.monitoring = false
	
	if State.state_number == 14 and game == null:
		init_patrol_mini_game()


func _process(_delta: float) -> void:

	match State.state_number:
		13:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						first_dialogue()
				1:
					if not dialog_is_running:
						dialog_is_running = true
						first_dialogue()
				7:
					miriam_path._play()
				9:
					miriam_path._finish_play()
					
				10:
					dialog_is_running = false
					State.state_phase = 0
					State.state_number = 14
					Signals.save_to_file.emit()

		14:
			match State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						second_dialogue()
				4:
					emil_path._play()
				7:
					emil_path._finish_play()
				13:
					dialog_is_running = false
					if game == null:
						init_patrol_mini_game()
					State.state_number = 15
					State.state_phase = 0

		16:
			match State.state_phase:
				0:
					State.state_phase = 0
					State.state_number = 16
					Save.player_position = Vector2(791,-465) 
					Save.current_scene_path = 'res://Scenes/Locations/Town/DanielHouse.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)

func init_patrol_mini_game() -> void:
	game = mini_game.instantiate()
	game.z_index = 1
	game.global_position = mini_game_position.global_position

	add_child(game)
	$PhantomCamera2D.follow_target = game
	
	player.hide()
	State.is_running = false

func finish_patrol_mini_game() -> void:
	$PhantomCamera2D.follow_target = player
	
	State.state_number = 16
	State.state_phase = 0
	

	if game != null:
		game.queue_free()
		game = null

	player.show()
	State.is_running = true


func first_dialogue() -> void:
	Signals.show_dialog.emit()

	#1
	Signals.people_message.emit("MiriamSchmidt", "You stubborn fool, you'll push your luck too far one day. What you're doing is really dangerous.", true)
	
	#2
	Signals.people_message.emit("MiriamSchmidt", "If I find out about this again, I won't cover for you anymore.", true)

	#3
	Signals.people_message.emit("EmilSchmidt", "Honey, calm down. Everything is under control.", true)

	#4
	Signals.people_message.emit("MiriamSchmidt", "Don't you sweet-talk me. I know what you're doing, and I don't like it.", true)

	#5
	Signals.people_message.emit("EmilSchmidt", "Miriam, please, a little trust. I know what I'm doing.", true)
	#6
	Signals.people_message.emit("EmilSchmidt", "Besides, it's for us. For our future.", true)

	#7
	Signals.player_message.emit("Daniel", "Ahem... Ahem..., am I interrupting?", true)

	#8
	Signals.player_message.emit("Daniel", "I know it's late, but I have a matter for Mr. Emil?", true)
	
	#9
	Signals.people_message.emit("MiriamSchmidt", "Of course, please come in. I'm heading home now.", true)
	
	#10
	Signals.people_message.emit("MiriamSchmidt", "Emil, when you're finished, I'll see you at home in an hour.", true)
	
	#11
	Signals.people_message.emit("EmilSchmidt", "Alright, darling,", true)


func second_dialogue() -> void:
	Signals.show_dialog.emit()

	#1
	Signals.people_message.emit("EmilSchmidt", "Hello Daniel, what brings you to me at such a late hour?", true)
	
	#2
	Signals.player_message.emit("Daniel", "Hi Emil, sorry to bother you. I just have a quick question.", true)
	
	#3
	Signals.player_message.emit("Daniel", "Do you know what these symbols are?", true)

	#4
	Signals.people_message.emit("EmilSchmidt", "Hmm... I'm not sure, but they look like runes.", true)

	#5
	Signals.people_message.emit("EmilSchmidt", "Give me a moment. I think they are symbols from an old legend.", true)
	
	#6
	Signals.people_message.emit("EmilSchmidt", "I should still have a volume about that legend in the shop. Wait a moment, I'll be right back.", true)

	#7
	Signals.player_message.emit("Daniel", "Alright. Wait, a legend about what?", true)

	#8
	Signals.people_message.emit("EmilSchmidt", "About the legend of the first bearers of the spark.", true)

	#9
	Signals.people_message.emit("EmilSchmidt", "Ah, here it is! I'm back. As I said, it's the legend of the first bearers of the spark. These symbols are assigned to specific sources of power. But I don't know this one, and I don't see it in this book.", true)

	#10
	Signals.player_message.emit("Daniel", "Thanks, Emil. That helps a lot.", true)

	#11
	Signals.player_message.emit("Daniel", "Emil, can I borrow this book?", true)

	#12
	Signals.people_message.emit("EmilSchmidt", "Forgive me, Daniel, but I can't let you do that. As you might have heard, my loving wife is very sensitive about me lending out books. Because some residents didn't return them and just left them scattered around the city.", true)
	#13
	Signals.people_message.emit("EmilSchmidt", "And Miriam found one of them and got upset.", true)

	#14
	Signals.people_message.emit("EmilSchmidt", "I have an idea - I'll let you buy this book. And as payment, you'll collect the books from the district and return them to me. Does that sound like a fair deal?", true)

	#15
	Signals.player_message.emit("Daniel", "Yes, that sounds fair.", true)

	#16
	Signals.people_message.emit("EmilSchmidt", "Good, I'm glad we've reached an agreement. So, take the book and head home.", true)

	#17
	Signals.player_message.emit("Daniel", "Thanks, Emil, see you. You should head home too and watch out for the night watch.", true)
