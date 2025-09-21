extends Node2D

@onready var guard7: NPC = $NPC/Guard7
@onready var guard8: NPC = $NPC/Guard8
@onready var peter: NPC = $NPC/Peter
@onready var player: Player = $Player
@onready var camer: PhantomCamera2D = $PhantomCamera2D

@onready var cart: Area2D = $EventArea/Cart
@onready var give_sheet: Area2D = $EventArea/GiveSTeelSheet
@onready var mini_game_pos: Marker2D = $EventArea/Cart/Marker2D

@onready var mini_game = load("res://Scenes/MiniGame/CartMinGame/cart_mini_gam.tscn")
const  MAIN_SCENE = "res://Scenes/World.tscn"
var game:Node = null
var game_load_finish: bool = false

func _ready() -> void:
	camer.global_position = player.global_position 
	camer.follow_target = player
	
	Signals.load_cart_game.connect(_load_game)
	Signals.finish_cart_game.connect(_finish_game)
	
	if State.state_number >= 3:
		cart.show()
	
	if State.state_number >= 4:
		cart.monitoring = false

	# Dodane: automatyczne wznowienie mini-gry po powrocie do sceny
	if State.state_number == 3 and game == null:
		_load_game()

func _process(_delta: float) -> void:
	if State.is_loading: return
	
	if cart.overlaps_body(player) and State.state_number != 3: _on_cart_mouse_entered()
	
	if give_sheet != null:
		if give_sheet.overlaps_area(player) and State.selected_item != null and State.selected_item.item_name == "Steel sheet": _reper_cart()
	
	match State.state_number:
		1:
			match State.state_phase:
				0: 
					_first_task()
					player.sprite.flip_h = true
				10:
					player.sprite.flip_h = false
					for i in 2:
						await get_tree().process_frame
					State.state_number = 2
					State.state_phase = 0
		2:
			match  State.state_phase:
				1:
					_second_task()
				5:
					if get_node_or_null("EventArea/GiveSTeelSheet") != null:
						$EventArea/GiveSTeelSheet/BrokenCart.hide()
						$EventArea/GiveSTeelSheet.queue_free()
						cart.show()
				8:
					_load_game()
					State.state_number = 3
					State.state_phase = 0
		3:
			State.is_running = false
		4:
			match  State.state_phase:
				0:
					_third_dialogue()
				1:
					var broken_wheel: Item = Item.new("Broken wheel",
						[],
						true,
						"res://Sprite/Items/BrokenCartWheelSmall.png",
						"res://Sprite/Items/BrokenCartWheel.png",
						[])
					if not Save._is_in_equipment(broken_wheel.item_name):
						broken_wheel.add_to_equipment()
				9:
					State.state_number = 5
					State.state_phase = 0
					Save.player_position = Vector2(440,-184) 
					Save.current_scene_path = 'res://Scenes/Locations/Town/Workshop.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(MAIN_SCENE)

func _on_area_2d_body_entered(body: Node2D) -> void:
	Signals.set_cursor.emit(State.Cursors.USE)
	if body.is_in_group("Player") and State.selected_item != null and State.selected_item.item_name == "Steel sheet":
		_reper_cart()

func  _reper_cart() -> void:
	State.state_phase = 1
	var stop_point: Vector2 = Vector2(2127,-54)
	player.global_position = stop_point
	player.navigation.target_position = stop_point
	player.sprite.play("idle")
	State.selected_item.remove_from_equipment()
	State.active_item = null
	Signals.reset_look_at_item.emit()

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
	Signals.people_message.emit("Guard7","Here's the damaged cart.It was too heavy, one of the wheels broke, and now it's blocking the track for the others.  ")
	
	#2
	Signals.people_message.emit("Guard8","Clear it up as quickly as you can and return to the mine.")

	#3
	Signals.player_message.emit("Daniel","Alright. We're on it, just give us a moment to examine what can be done about it.")
	
	
	#4
	Signals.people_message.emit("Guard8","Okay, okay, do what you have to do, just don't get in our way.Understood?")

	#5
	Signals.player_message.emit("Daniel","Understood. Peter, come on, let's see what we can do.")
	
	#6
	Signals.people_message.emit("Peter", "The wheel is completely broken. I don't know if I can help here.")
	#7
	Signals.people_message.emit("Guard7", "What do you mean? Your Spark lets you shape metal. Can't you form a new wheel?")
	
	#8
	Signals.people_message.emit("Peter", "My Spark has limitations. I can't freely reshape things. I need the right amount of material to create something. These pieces are too small for me to form a new wheel. If I had a piece of sheet metal or a metal bar, I'd be able to create one. From these scraps, it's going to be hard to make a new, durable wheel.")
	
	#9
	Signals.player_message.emit("Daniel", "Peter, stay here. I'll look around the platform maybe I'll find something. In the meantime, try to work on shaping a new wheel.")

func _second_task() -> void:
	Save.save_data_to_file()
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel", "Peter, will this sheet metal do?")
	#2
	Signals.people_message.emit("Peter", "Yeah, I think I can make a wheel out of this.")
	#3
	Signals.people_message.emit("Peter", "Alright. That’s the best wheel I can make. Daniel, can you lift the cart a little?")
	#4
	Signals.player_message.emit("Daniel", "Alright, got it.")
	#5
	Signals.people_message.emit("Guard8", "Couldn't you be any slower? And what is that supposed to be? Why is the wheel so uneven?")
	#6
	Signals.people_message.emit("Peter", "Bbbbbut... I-I-I d-don't... c-control the Spark that well. I can reshape metal b-b-but... it doesn’t come out p-p-perfect...")
	#7
	Signals.people_message.emit("Guard7", "Alright, alright. What matters is that you fixed it. But the loading is already way behind schedule. Push the cart through the emergency track and get back to the mine.")
	State.state_phase = 2

func  _third_dialogue() -> void:
	Save.save_data_to_file()
	Signals.show_dialog.emit()
	player.sprite.play("idle")
	
	#1
	Signals.people_message.emit("Peter", "Psst... Daniel, look what I found while we were moving the cart.")
	#2
	Signals.player_message.emit("Daniel", "Wait, what is this? A Resistance poster?! Hide it, or they'll do something to us!")
	#3
	Signals.people_message.emit("Guard8", "What's going on there? What do you have?")
	#4
	Signals.player_message.emit("Daniel", "I was just handing Peter a rag so he could wipe his forehead—he got all sweaty from the coal.")
	#5
	Signals.people_message.emit("Guard7", "And are you done with that cart yet?")
	#6
	Signals.player_message.emit("Daniel", "Yes. We pushed the cart all the way through.")
	#7
	Signals.people_message.emit("Guard7", "Peter, you go back to the mine, and Daniel, you take this broken wheel. Go to the twins and ask them to repair it.")
	#8
	Signals.player_message.emit("Daniel", "Okay. After I give it to them, should I return to the mine right away?")
	#9
	Signals.people_message.emit("Guard8", "No, wait there until they fix the wheel, and only then go back to the mine. Don't waste time—go.")
