extends Node2D

@export var info_panel: InfoPanel

@onready var guard7: NPC = $NPC/Guard7
@onready var guard8: NPC = $NPC/Guard8
@onready var peter: NPC = $NPC/Peter
@onready var player: Player = $Player
@onready var camer: PhantomCamera2D = $PhantomCamera2D

@onready var cart: Area2D = $EventArea/Cart
@onready var give_sheet: Area2D = $EventArea/GiveSteelSheet
@onready var mini_game_pos: Marker2D = $EventArea/Cart/Marker2D

@onready var mini_game = load("res://Scenes/MiniGame/CartMinGame/cart_mini_gam.tscn")
var game:Node = null
var game_load_finish: bool = false

var player_find_steel_sheet: bool = false
var steel_sheet_picked_up: bool = false

var dialog_is_running: bool = false

func _ready() -> void:
	camer.global_position = player.global_position 
	camer.follow_target = player
	
	Signals.load_cart_game.connect(_load_game)
	Signals.finish_cart_game.connect(_finish_game)

	if (State.state_number == 2 and State.state_phase < 4) or (State.state_number >= 1 and State.state_phase >= 10):
		Signals.change_info_panel_visibility.emit(true)

	if State.state_number >= 3:
		cart.show()
	
	if State.state_number >= 4:
		cart.monitoring = false
	
	if State.state_number == 3 and game == null:
		_load_game()
		Signals.change_info_panel_visibility.emit(false)
	
	if State.state_number >= 7:
		give_sheet.monitoring = false

func _process(_delta: float) -> void:
	if State.is_loading: return

	# Sprawdzamy czy gracz ma steel_sheet w ekwipunku
	if Save._is_in_equipment("Steel sheet") and not steel_sheet_picked_up:
		Signals.change_info_panel_text.emit("Give the steel sheet to Peter")
		steel_sheet_picked_up = true

	
	if player_find_steel_sheet and steel_sheet_picked_up and State.selected_item != null and State.selected_item.item_name == "Steel sheet":
		player_find_steel_sheet = false
		_reper_cart()
	
	match State.state_number:
		1:
			match State.state_phase:
				0: 
					if not dialog_is_running:
						dialog_is_running = true
						_first_task()
						player.sprite.flip_h = true
				8:
					player.sprite.flip_h = false
					for i in 2:
						await get_tree().process_frame
					
					dialog_is_running = false
					Signals.change_info_panel_visibility.emit(true)
					State.state_number = 2
					State.state_phase = 0
		2:
			match  State.state_phase:
				4:
					if get_node_or_null("EventArea/GiveSteelSheet") != null:
						$EventArea/GiveSteelSheet/BrokenCart.hide()
						$EventArea/GiveSteelSheet.queue_free()
						cart.show()
						
						_load_game()
						State.state_number = 3
						State.state_phase = 0
						Signals.change_info_panel_visibility.emit(false)
		4:
			match  State.state_phase:
				0:
					if not dialog_is_running:
						dialog_is_running = true
						_third_dialogue()
				1:
					var broken_wheel: Item = Item.new("Broken wheel",[],true,"res://Sprite/Items/BrokenCartWheelSmall.png","res://Sprite/Items/BrokenCartWheel.png",[])
					if not Save._is_in_equipment(broken_wheel.item_name):
						broken_wheel.add_to_equipment()
				7:
					dialog_is_running = false
					State.state_number = 5
					State.state_phase = 0
					Save.player_position = Vector2(440,-184) 
					Save.current_scene_path = 'res://Scenes/Locations/Town/Workshop.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)

func _on_give_steel_sheet_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_find_steel_sheet = true

func _on_give_steel_sheet_body_exited(body:Node2D) -> void:
	if body.is_in_group("Player"):
		player_find_steel_sheet = false

func  _reper_cart() -> void:
	var stop_point: Vector2 = Vector2(2127,-54)
	player.global_position = stop_point
	player.navigation.target_position = stop_point
	player.sprite.play("idle")
	State.selected_item.remove_from_equipment()
	State.active_item = null
	Signals.reset_look_at_item.emit()
	_second_task()  # Teraz _second_task wywoła się dopiero po użyciu przedmiotu

func _on_cart_mouse_entered() -> void:
	
	if State.state_number != 3 : return
	var pl_pos = player.global_position
	var mouse_pos = get_global_mouse_position()
	if mouse_pos.distance_to(player.global_position) <= 30:
		player.hide()
		player.global_position = pl_pos
		player.navigation.target_position = pl_pos

func _load_game()-> void:
	game = mini_game.instantiate()
	game.z_index = 1
	game.global_position = mini_game_pos.global_position
	add_child(game)
	$PhantomCamera2D.follow_target = game
	game_load_finish = true
	player.hide()
	State.is_running = false

func _finish_game()-> void:
	$PhantomCamera2D.follow_target = player
	player.show()
	State.state_number = 4
	State.state_phase = 0
	$EventArea/Cart.monitoring = false
	State.is_running = true

func _first_task() -> void:
	var stop: Vector2 = Vector2(2127,-74)
	
	player.global_position = stop
	player.navigation.target_position = stop
	Signals.show_dialog.emit()
	player.sprite.play("idle")
	#1
	Signals.people_message.emit("Guard7","Here's the damaged cart.It was too heavy, one of the wheels broke, and now it's blocking the track for the others.", true)
	#2
	Signals.people_message.emit("Guard8","Clear it up as quickly as you can and return to the mine.", true)
	#3
	Signals.player_message.emit("Daniel","Alright. We're on it, just give us a moment to examine what can be done about it.", true)
	#4
	Signals.people_message.emit("Guard8","Okay, okay, do what you have to do, just don't get in our way. Understood?", true)
	#5
	Signals.player_message.emit("Daniel","Understood. Peter, come on, let's see what we can do.", true)
	#6
	Signals.people_message.emit("Peter", "The wheel is completely broken. I don't know if I can help here.", true)
	#7
	Signals.people_message.emit("Guard7", "What do you mean? Your Spark lets you shape metal. Can't you form a new wheel?", true)
	#8
	Signals.people_message.emit("Peter", "My Spark has limitations. I can't freely reshape things. I need the right amount of material to create something. These pieces are too small for me to form a new wheel. If I had a piece of sheet metal or a metal bar, I'd be able to create one. From these scraps, it's going to be hard to make a new, durable wheel.", true)
	#9
	Signals.player_message.emit("Daniel", "Peter, stay here. I'll look around the platform maybe I'll find something. In the meantime, try to work on shaping a new wheel.", true)

func _second_task() -> void:
	Save.save_data_to_file()
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel", "Peter, will this sheet metal do?", true)
	#2
	Signals.people_message.emit("Peter", "Yeah, I think I can make a wheel out of this.", true)
	#3
	Signals.people_message.emit("Peter", "Alright. That’s the best wheel I can make. Daniel, can you lift the cart a little?", true)
	#4
	Signals.player_message.emit("Daniel", "Alright, got it.", true)
	#5
	Signals.people_message.emit("Guard8", "Couldn't you be any slower? And what is that supposed to be? Why is the wheel so uneven?", true)
	#6
	Signals.people_message.emit("Peter", "BBBBBbut... I-I-I d-don't... c-control the Spark that well. I can reshape metal b-b-but... it doesn’t come out p-p-perfect...", true)
	#7
	Signals.people_message.emit("Guard7", "Alright, alright. What matters is that you fixed it. But the loading is already way behind schedule. Push the cart through the emergency track and get back to the mine.", true)

func  _third_dialogue() -> void:
	Save.save_data_to_file()
	Signals.show_dialog.emit()
	player.sprite.play("idle")
	
	#1
	Signals.people_message.emit("Peter", "Psst... Daniel, look what I found while we were moving the cart.", true)
	#2
	Signals.player_message.emit("Daniel", "Wait, what is this? A Resistance poster?! Hide it, or they'll do something to us!", true)
	#3
	Signals.people_message.emit("Guard8", "What's going on there? What do you have?", true)
	#4
	Signals.player_message.emit("Daniel", "I was just handing Peter a rag so he could wipe his forehead—he got all sweaty from the coal.", true)
	#5
	Signals.people_message.emit("Guard7", "And are you done with that cart yet?", true)
	#6
	Signals.player_message.emit("Daniel", "Yes. We pushed the cart all the way through.", true)
	#7
	Signals.people_message.emit("Guard7", "Peter, you go back to the mine, and Daniel, you take this broken wheel. Go to the twins and ask them to repair it.", true)
	#8
	Signals.player_message.emit("Daniel", "Okay. After I give it to them, should I return to the mine right away?", true)
	#9
	Signals.people_message.emit("Guard8", "No, wait there until they fix the wheel, and only then go back to the mine. Don't waste time—go.", true)