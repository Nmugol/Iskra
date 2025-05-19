extends Node2D

@onready var guard7: NPC = $NPC/Guard7
@onready var guard8: NPC = $NPC/Guard8
@onready var peter: NPC = $NPC/Peter

func _process(_delta: float) -> void:
	if not State.LevelIsLoad: return
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

func _first_task() -> void:
	Signals.show_dialog.emit()
	
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
