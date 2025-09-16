extends Node2D


@export var player: Player

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


func _ready() -> void:
	if State.state_number == 13:
		emil.show()
		miriam.show()

		player.navigation.target_position = player_pos
		player.global_position = player_pos

		exit_1.monitorable = false
		exit_1.monitoring = false
		exit_2.monitorable = false        
		exit_2.monitoring = false
	
	if State.state_number == 14:
		emil.show()

		exit_1.monitorable = false
		exit_1.monitoring = false
		exit_2.monitorable = false        
		exit_2.monitoring = false
	



func _process(_delta: float) -> void:
	if State.is_loading: return

	match State.state_number:
		13:
			match State.state_phase:
				0:
					first_dialogue()
				9:
					miriam_path._play()
				11:
					miriam_path._finish_play()
					
				12:
					State.state_phase = 0
					State.state_number = 14
					Signals.save_to_file.emit()
		14:
			match State.state_phase:
				0:
					second_dialogue()
				6:
					emil_path._play()
				9:
					emil_path._finish_play()


func first_dialogue() -> void:
	Signals.show_dialog.emit()

	#1
	Signals.people_message.emit("MiriamSchmidt", "You stubborn fool, you'll push your luck too far one day. What you're doing is really dangerous.")
	
	#2
	Signals.people_message.emit("MiriamSchmidt", "If I find out about this again, I won't cover for you anymore.")

	#3
	Signals.people_message.emit("EmilSchmidt", "Honey, calm down. Everything is under control.")

	#4
	Signals.people_message.emit("MiriamSchmidt", "Don't you sweet-talk me. I know what you're doing, and I don't like it.")

	#5
	Signals.people_message.emit("EmilSchmidt", "Miriam, please, a little trust. I know what I'm doing.")
	#6
	Signals.people_message.emit("EmilSchmidt", "Besides, it's for us. For our future.")

	#7
	Signals.player_message.emit("Daniel", "Ahem... Ahem..., am I interrupting?")

	#8
	Signals.player_message.emit("Daniel", "I know it's late, but I have a matter for Mr. Emil?")
	
	#9
	Signals.people_message.emit("MiriamSchmidt", "Of course, please come in. I'm heading home now.")
	
	#10
	Signals.people_message.emit("MiriamSchmidt", "Emil, when you're finished, I'll see you at home in an hour.")
	
	#11
	Signals.people_message.emit("EmilSchmidt", "Alright, darling,")

	print("State number:",State.state_number, "State phase:" ,State.state_phase)


func second_dialogue() -> void:
	Signals.show_dialog.emit()

	#1
	Signals.people_message.emit("EmilSchmidt", "Hello Daniel, what brings you to me at such a late hour?")
	
	#2
	Signals.player_message.emit("Daniel", "Hi Emil, sorry to bother you. I just have a quick question.")
	
	#3
	Signals.player_message.emit("Daniel", "Do you know what these symbols are?")

	#4
	Signals.people_message.emit("EmilSchmidt", "Hmm... I'm not sure, but they look like runes.")

	#5
	Signals.people_message.emit("EmilSchmidt", "Give me a moment. I think they are symbols from an old legend.")
	
	#6
	Signals.people_message.emit("EmilSchmidt", "I should still have a volume about that legend in the shop. Wait a moment, I'll be right back.")

	#7
	Signals.player_message.emit("Daniel", "Alright. Wait, a legend about what?")

	#8
	Signals.people_message.emit("EmilSchmidt", "About the legend of the first bearers of the spark.")

	#9
	Signals.people_message.emit("EmilSchmidt", "Ah, here it is! I'm back. As I said, it's the legend of the first bearers of the spark. These symbols are assigned to specific sources of power. But I don't know this one, and I don't see it in this book.")

	#10
	Signals.player_message.emit("Daniel", "Thanks, Emil. That helps a lot." )

	#11
	Signals.player_message.emit("Daniel", "Emil, can I borrow this book?")

	#12
	Signals.people_message.emit("EmilSchmidt", "Forgive me, Daniel, but I can't let you do that. As you might have heard, my loving wife is very sensitive about me lending out books. Because some residents didn't return them and just left them scattered around the city.")
	#13
	Signals.people_message.emit("EmilSchmidt", "And Miriam found one of them and got upset.")

	#14
	Signals.people_message.emit("EmilSchmidt", "I have an idea - I'll let you buy this book. And as payment, you'll collect the books from the district and return them to me. Does that sound like a fair deal?")

	#15
	Signals.player_message.emit("Daniel", "Yes, that sounds fair.")

	#16
	Signals.people_message.emit("EmilSchmidt", "Good, I'm glad we've reached an agreement. So, take the book and head home.")

	#17
	Signals.player_message.emit("Daniel", "Thanks, Emil, see you. You should head home too and watch out for the night watch.")
