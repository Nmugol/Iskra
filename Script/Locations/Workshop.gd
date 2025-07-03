extends Node2D

@onready var player: Player = $Player
const  MainScene = "res://Scenes/World.tscn"

@onready var jonas: NPC = $NPCS/Jonas
@onready var james: NPC = $NPCS/James

func set_up() -> void:
	if State.StateNumber != 5:
		jonas.show()
		james.show()
	else:
		james.show()
		jonas.hide()

func _ready() -> void:
	set_up()

func _process(_delta: float) -> void:
	match State.StateNumber:
		5:
			match State.StatePhase:
				0:
					jonas.hide()
					_first_dialog()
				3:
					jonas.show()
				9:
					State.StatePhase = 0
					State.StateNumber = 6
					james.hide()
					Save._remove_item("Broken whell")
		7:
			match  State.StatePhase:
				0:
					_second_dialog()
				1:
					james.show()
					var blocking_areas = $BlockingAreas
					if blocking_areas:
						var area = blocking_areas.get_node_or_null("Area2D")
						if area:
							area.queue_free()
				7:
					State.StateNumber = 8
					State.StatePhase = 0
					Save.PlayerPosition = Vector2(792,1616) 
					Save.CurrentScenePath = 'res://Scenes/Locations/Mines/MineHub.tscn'
					Signals.enable_loadin_screen.emit()
					get_tree().change_scene_to_file(MainScene)

func _first_dialog() -> void:

	player.sprite.play("idle")
	Signals.show_dialog.emit()
	
	#1
	Signals.peopel_message.emit("James",
	"
	Hey, Daniel! Do you have any idea why the patrols are checking every house and shop today?
	")

	#2
	Signals.player_message.emit("Daniel",
	"
	Keep it down... Look what I found earlier – a Resistance poster.
	Quick summary – we were moving a cart, and Peter spotted it stuck under the rails.
	")

	#3
	Signals.peopel_message.emit("James",
	"
	A Resistance poster?! No wonder they're on edge...
	Wait... do you hear that?
	")

	#4
	Signals.peopel_message.emit("Jonas",
	"
	[shake rate=10.0 level=2]Boom![/shake]
	Dammit, James! Are you messing with my tools again?! I told you not to touch the compressor!
	")

	#5
	Signals.peopel_message.emit("James",
	"
	Jonas! Calm down, it's not my fault!
	Anyway, Daniel, what did you bring here?
	")

	#6
	Signals.player_message.emit("Daniel",
	"
	I’ve got a broken cart wheel. The patrols sent me – they ordered a quick repair.
	")

	#7
	Signals.peopel_message.emit("James",
	"
	Always those guys... Alright, give me the wheel. It'll take a minute.
	Just... don't touch anything while you're waiting, okay?
	")

	#8
	Signals.player_message.emit("Daniel",
	"
	Got it. Thanks, James.
	")

func _second_dialog() -> void:
	player.sprite.play("idle")
	Signals.show_dialog.emit()
	
	#1
	Signals.player_message.emit("Daniel",
	"
	Whoa, what's this...? A small, chipped crystal. Huh... Looks like part of a machine.
	Maybe Jonas knows.
	")

	#2
	Signals.player_message.emit("Daniel",
	"
	Jonas, do you know what this is?
	")

	#3
	Signals.peopel_message.emit("Jonas",
	"
	No clue, kid. If it’s small and broken, it’s yours. I’ve got enough junk to deal with.
	")

	#4
	Signals.peopel_message.emit("James",
	"
	Alright, here’s the wheel – fixed and ready. Get it out of here fast.
	Look, the patrol is coming.
	")

	#5
	Signals.peopel_message.emit("Guard6",
	"
	The wheel. Give it to us.
	")

	#6
	Signals.player_message.emit("Daniel",
	"
	Here it is, sir.
	")

	#7
	Signals.peopel_message.emit("Guard6",
	"
	Good. Now back to the mine. We’ll be watching.
	")


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Save._is_in_equipment("Crystal shard") == true:
		State.StatePhase = 0
		State.StateNumber = 7
		$Events/Area2D.queue_free()
