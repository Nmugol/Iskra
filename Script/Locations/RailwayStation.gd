extends Node2D

@onready var guard7: NPC = $NPC/Guard7
@onready var guard8: NPC = $NPC/Guard8
@onready var peter: NPC = $NPC/Peter
@onready var player: Player = $Player

@onready var cart: Area2D = $EventArea/Cart
@onready var give_sheet: Area2D = $EventArea/GiveSTeelSheet

@onready var minigame = load("res://Scenes/MiniGame/CartMinGame/cart_mini_gam.tscn")
const  MainScene = "res://Scenes/World.tscn"

func _ready() -> void:
	
	Signals.load_cart_game.connect(_load_game)
	Signals.finish_cart_game.connect(_finish_game)
	
	if State.StateNumber >= 3:
		$EventArea/GiveSTeelSheet.queue_free()
		$EventArea/Cart.show()
	
	if State.StateNumber >= 4:
		$EventArea/Cart.monitoring = false

func _process(_delta: float) -> void:
	if not State.LevelIsLoad: return
	
	if cart.overlaps_body(player) and State.StateNumber != 3:
		_on_cart_mouse_entered()
	
	if give_sheet.overlaps_area(player) and State.SelectedItem != null and State.SelectedItem.item_name == "Steel sheet":
		_reper_cart()
	
	match State.StateNumber:
		1:
			match State.StatePhase:
				0: 
					_first_task()
					$Player.sprite.flip_h = true
				10:
					$Player.sprite.flip_h = false
					State.StateNumber = 2
					State.StatePhase = 0
		2:
			match  State.StatePhase:
				1:
					_secon_task()
				5:
					if get_node_or_null("EventArea/GiveSTeelSheet") != null:
						$EventArea/GiveSTeelSheet/BrokenCart.hide()
						$EventArea/GiveSTeelSheet.queue_free()
						$EventArea/Cart.show()
						
				8:
					State.StateNumber = 3
					State.StatePhase = 0
		4:
			match  State.StatePhase:
				0:
					_third_dialogue()
				1:
					var broken_whell: Item = Item.new("Broken whell",[],true,"res://Sprite/Items/BrokenCartWhellSmall.png","res://Sprite/Items/BrokenCartWhell.png",[])
					broken_whell.AddToEquipment()
				4:
					State.StateNumber = 5
					State.StatePhase = 0
					Save.PlayerPosition = Vector2(-368,568) 
					Save.CurrentScenePath = "res://Scenes/Locations/RailwayStation/RailwayStation.tscn"
					Signals.enable_loadin_screen.emit()
					get_tree().change_scene_to_file(MainScene)

func _on_area_2d_body_entered(body: Node2D) -> void:
	Signals.set_coursor.emit(State.Coursors.USE)
	if body.is_in_group("Player") and State.SelectedItem != null and State.SelectedItem.item_name == "Steel sheet":
		_reper_cart()

func  _reper_cart() -> void:
	State.StatePhase = 1
	var stop_point: Vector2 = Vector2(2127,-54)
	player.global_position = stop_point
	player.nav.target_position = stop_point
	player.sprite.play("idle")
	State.SelectedItem.RemoveFromEquipment()

func _on_cart_mouse_entered() -> void:
	if State.StateNumber != 3 : return
	var pl_pos = player.global_position
	var mous_pos = get_global_mouse_position()
	if mous_pos.distance_to(player.global_position) <= 30:
		player.hide()
		player.global_position = pl_pos
		player.nav.target_position = pl_pos
		State.IsRun = false
		_load_game()

func _load_game()-> void:
	var game = minigame.instantiate()
	game.z_index = 1
	game.global_position = $CartMiniGamePos.global_position
	add_child(game)
	$PhantomCamera2D.follow_target = game

func _finish_game()-> void:
	$PhantomCamera2D.follow_target = player
	player.show()
	State.StateNumber = 4
	State.StatePhase = 0
	$EventArea/Cart.monitoring = false
	State.IsRun = true

func  _third_dialogue() -> void:
	Save.SaveDataToFile()
	Signals.show_dialog.emit()
	player.sprite.play("idle")
	
	#1
	Signals.peopel_message.emit("Guard7",
	"
	Peter, you go back to the mine, and Daniel, you take this broken wheel.
	Go to the twins and ask them to repair it.
	")
	
	#2
	Signals.player_message.emit("Daniel",
	"
	Okay. After I give it to them, should I return to the mine right away?
	")
	
	#3
	Signals.peopel_message.emit("Guard8",
	"
	No, wait there until they fix the wheel, and only then go back to the mine.
	Don't waste time—go.
	")

func _first_task() -> void:
	var stop: Vector2 = Vector2(2127,-74)
	
	player.global_position = stop
	player.nav.target_position = stop
	Signals.show_dialog.emit()
	player.sprite.play("idle")
	#1
	Signals.peopel_message.emit("Guard7",
	"
	Here's the damaged cart.
	It was too heavy, one of the wheels broke, and now it's blocking the track for the others.  
	")
	
	#2
	Signals.peopel_message.emit("Guard8",
	"
	Clear it up as quickly as you can and return to the mine. 
	")
	
	#3
	Signals.player_message.emit("Daniel",
	"
	Alright. We're on it, just give us a moment to examine what can be done about it. 
	")
	
	#4
	Signals.peopel_message.emit("Guard8",
	"
	Okay, okay, do what you have to do, just don't get in our way.
	Understood?
	")
	
	#5
	Signals.player_message.emit("Daniel",
	"
	Understood.
	
	Peter, come on, let's see what we can do.
	")
	
	#6
	Signals.peopel_message.emit("Peter",
	"
	The wheel is completely broken. I don't know if I can help here. 
	")
	
	#7
	Signals.peopel_message.emit("Guard7",
	"
	What do you mean? Your Spark lets you shape metal. Can't you form a new wheel? 
	")
	
	#8
	Signals.peopel_message.emit("Peter",
	"
	My Spark has limitations. I can't freely reshape things.
	I need the right amount of material to create something.
	These pieces are too small for me to form a new wheel.
	If I had a piece of sheet metal or a metal bar, I'd be able to create one.
	
	From these scraps, it's going to be hard to make a new, durable wheel.
	")
	
	#9
	Signals.player_message.emit("Daniel",
	"
	Peter, stay here. I'll look around the platform maybe I'll find something.
	In the meantime, try to work on shaping a new wheel.
	")

func _secon_task() -> void:
	Save.SaveDataToFile()
	Signals.show_dialog.emit()
	#1
	Signals.player_message.emit("Daniel",
	"
	Peter, will this sheet metal do?
	")
	#2
	Signals.peopel_message.emit("Peter",
	"
	Yeah, I think I can make a wheel out of this.
	")
	#3
	Signals.peopel_message.emit("Peter",
	"
	Alright. That’s the best wheel I can make.
	Daniel, can you lift the cart a little?
	")
	#4
	Signals.player_message.emit("Daniel",
	"
	Alright, got it.
	")
	#5
	Signals.peopel_message.emit("Guard8",
	"
	[b]Couldn't you be any slower?[/b]
	And what is that supposed to be? Why is the wheel so uneven?
	")
	#6
	Signals.peopel_message.emit("Peter",
	"
	Bbbbbut...
	I-I-I d-don't... c-control the Spark that well.
	I can reshape metal b-b-but... it doesn’t come out p-p-perfect...
	")
	#7
	Signals.peopel_message.emit("Guard7",
	"
	Alright, alright.
	What matters is that you fixed it. But the loading is already way behind schedule.
	Push the cart through the emergency track and get back to the mine.
	")
