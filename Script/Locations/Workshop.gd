extends Node2D

@onready var player: Player = $Player

@export_category("NPCs")
@export var jonas: NPC
@export var james: NPC
@export var guard6: NPC

@export_category("Paths")
@export var james_out: PathController
@export var jonas_in: PathController
@export var james_in: PathController
@export var guard_in: PathController

var player_in_area: bool = false


func set_up() -> void:
	guard6.hide()
	if State.state_number != 5:
		jonas.show()
		james.show()
	else:
		james.show()
		jonas.hide()


func _ready() -> void:
	set_up()


func _process(_delta: float) -> void:
	if State.is_loading:
		return

	if player_in_area and Save._is_in_equipment("Crystal shard") == true:
		State.state_phase = 0
		State.state_number = 7
		$Events/Area2D.queue_free()

	match State.state_number:
		5:
			match State.state_phase:
				0:
					jonas.hide()
					_first_dialog()
				1:
					jonas.show()
					var smoke = $Particle/Smoke
					smoke.play = true
					jonas_in._play()
				2:
					jonas.update_state("idle", true)
				6:
					james_out._play()
				7:
					State.state_phase = 0
					State.state_number = 6
					james.hide()
					Save._remove_item("Broken wheel")
					Signals.change_info_panel_visibility.emit(true)
		7:
			match State.state_phase:
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
					james.show()
					james_in._play()
					player.navigation.target_position = $Events/FixedWheelPosition.global_position
				2:
					player.global_position = $Events/FixedWheelPosition.global_position
					james_in.path.progress_ratio = 1
					james.update_state("Idle", true)
					guard_in._play()
					guard6.show()
				3:
					guard_in.path.progress_ratio = guard_in.stop_points
					guard6.update_state("Idle", true)
				5:
					State.state_number = 8
					State.state_phase = 0
					Save.player_position = Vector2(792, 1616)
					Save.current_scene_path = 'res://Scenes/Locations/Mines/MineHub.tscn'
					Signals.enable_loading_screen.emit()
					get_tree().change_scene_to_file(State.MAIN_SCENE)


func _first_dialog() -> void:
	player.sprite.play("idle")
	Signals.show_dialog.emit()

	Signals.people_message.emit("James", "Hey, Daniel! Do you have any idea why the patrols are checking every house and shop today?", true)
	Signals.player_message.emit("Daniel", "Keep it down... Look what I found earlier – a Resistance poster. Quick summary – we were moving a cart, and Peter spotted it stuck under the rails.", true)
	Signals.people_message.emit("James", "A Resistance poster?! No wonder they're on edge... Wait... do you hear that?", true)
	Signals.people_message.emit("Jonas", "[shake rate=10.0 level=2]Boom![/shake] Dammit, James! Are you messing with my tools again?! I told you not to touch the compressor!", true)
	Signals.people_message.emit("James", "Jonas! Calm down, it's not my fault!", true)
	Signals.player_message.emit("Daniel", "I've got a broken cart wheel. The patrols sent me - they ordered a quick repair.", true)
	Signals.people_message.emit("James", "Always those guys... Alright, give me the wheel. It'll take a minute. Just... don't touch anything while you're waiting, okay?", true)
	Signals.player_message.emit("Daniel", "Got it. Thanks, James.", true)


func _second_dialog() -> void:
	player.sprite.play("idle")
	Signals.show_dialog.emit()

	Signals.player_message.emit("Daniel", "Whoa, what's this...? A small, chipped crystal. Huh... Looks like part of a machine. Maybe Jonas knows.", true)
	Signals.player_message.emit("Daniel", "Jonas, do you know what this is?", true)
	Signals.people_message.emit("Jonas", "No clue, kid. If it’s small and broken, it’s yours. I’ve got enough junk to deal with.", true)
	Signals.people_message.emit("James", "Alright, here’s the wheel – fixed and ready. Get it out of here fast. Look, the patrol is coming.", true)
	Signals.people_message.emit("Guard6", "The wheel. Give it to us.", true)
	Signals.player_message.emit("Daniel", "Here it is, sir.", true)
	Signals.people_message.emit("Guard6", "Good. Now back to the mine. We’ll be watching.", true)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_area = false
