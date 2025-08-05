extends Node2D

const  MainScene = "res://Scenes/World.tscn"

@onready var player: Player = $Player

#NPC
@onready var jonas: NPC = $NPCS/Path/Jonas_in/PathFollow2D/Jonas
@onready var james: NPC = $NPCS/Path/James_out/PathFollow2D/James
@onready var guard6: NPC = $NPCS/Path/Guard6_in/PathFollow2D/Guard6

#PATH
@onready var james_out:PathController = $NPCS/Path/James_out
@onready var jonas_in:PathController = $NPCS/Path/Jonas_in
@onready var james_in:PathController = $NPCS/Path/James_in
@onready var guard_in:PathController = $NPCS/Path/Guard6_in

func set_up() -> void:
	if State.state_number != 5:
		jonas.show()
		james.show()
	else:
		james.show()
		jonas.hide()

func _ready() -> void:
	set_up()

func _process(_delta: float) -> void:
	if State.is_loading: return
	
	match State.state_number:
		5:
			match State.state_phase:
				0:
					jonas.hide()
					_first_dialog()
				3:
					jonas.show()
					var smoke = $Particle/Smoke
					smoke.play = true
					jonas_in._play()
				4:
					jonas.update_state("idle",true)
				8:
					james_out._play()
				9:
					State.state_phase = 0
					State.state_number = 6
					james.hide()
					Save._remove_item("Broken wheel")
		7:
			match  State.state_phase:
				0:
					james.reparent($NPCS/Path/James_in/PathFollow2D)
					james_in.npc = james
					_second_dialog()
				1:
					
					var blocking_areas = $BlockingAreas
					if blocking_areas:
						var area = blocking_areas.get_node_or_null("Area2D")
						if area:
							area.queue_free()
				3:
					james.show()
					james_in._play()
					player.navigation.target_position = $Events/FixedWheelPosition.global_position
				4:
					player.global_position = $Events/FixedWheelPosition.global_position
					james_in.path.progress_ratio = 1
					james.update_state("Idle", true)
					guard_in.active = true
					guard6.show()
				5:
					guard_in.path.progress_ratio = guard_in.stop_points
					guard6.update_state("Idle", true)
				7:
					State.state_number = 8
					State.state_phase = 0
					Save.player_position = Vector2(792,1616) 
					Save.current_scene_path = 'res://Scenes/Locations/Mines/MineHub.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(MainScene)

func _first_dialog() -> void:

	player.sprite.play("idle")
	Signals.show_dialog.emit()
	
	#1
	Signals.people_message.emit("James",
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
	Signals.people_message.emit("James",
	"
	A Resistance poster?! No wonder they're on edge...
	Wait... do you hear that?
	")

	#4
	Signals.people_message.emit("Jonas",
	"
	[shake rate=10.0 level=2]Boom![/shake]
	Dammit, James! Are you messing with my tools again?! I told you not to touch the compressor!
	")

	#5
	Signals.people_message.emit("James",
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
	Signals.people_message.emit("James",
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
	Signals.people_message.emit("Jonas",
	"
	No clue, kid. If it’s small and broken, it’s yours. I’ve got enough junk to deal with.
	")

	#4
	Signals.people_message.emit("James",
	"
	Alright, here’s the wheel – fixed and ready. Get it out of here fast.
	Look, the patrol is coming.
	")

	#5
	Signals.people_message.emit("Guard6",
	"
	The wheel. Give it to us.
	")

	#6
	Signals.player_message.emit("Daniel",
	"
	Here it is, sir.
	")

	#7
	Signals.people_message.emit("Guard6",
	"
	Good. Now back to the mine. We’ll be watching.
	")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and Save._is_in_equipment("Crystal shard") == true:
		State.state_phase = 0
		State.state_number = 7
		$Events/Area2D.queue_free()
