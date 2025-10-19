extends Node2D

@export var _player: Player

@export_category("NPC")
@export var supervisor: NPC

var dialog_is_running: bool =false 

@export_category("Mini game options")
@export var mini_game_pos: Marker2D
var stone_mini_game = load("res://Scenes/MiniGame/StoneMiniGame/StoneMiniGame.tscn")
var mini_game_is_running: bool = false
var game: Node = null

func _ready() -> void:
    match State.state_number:
        21:
            match State.state_phase:
                0:
                    supervisor.show()
        22:
            match State.state_phase:
                2:
                    _start_stone_mini_game()
        _:
            supervisor.hide()

func _process(_delta: float) -> void:
    if mini_game_is_running or State.is_loading: return

    if State.state_number == 22 and State.state_phase == 2 and game != null:
        _start_stone_mini_game()

    match State.state_number:
        21:
            match State.state_phase:
                0:
                    if not dialog_is_running:
                        _first_dialog()
                5:
                    dialog_is_running = false
                    Signals.change_info_panel_text.emit("Go to the crew and start clearing the stones from the tunnel.")
                    Signals.change_info_panel_visibility.emit(true)
                    State.state_number = 22
                    State.state_phase = 0



func _first_dialog() -> void:
    Signals.show_dialog.emit()
    Signals.people_message.emit("Przemek", "Daniel, what is it again this time? I'm listening, why are you late?", true)
    Signals.player_message.emit("Daniel", "Sir, to be honest, I overslept. Yesterday was a pretty intense day, and well...", true)
    Signals.people_message.emit("Przemek", "Alright, don't waste my time here, just get to the lads. They're already waiting for you by the lower shaft.", true)
    Signals.people_message.emit("Przemek", "You will be moving stones and clearing the passage, and they will be taking out the waste.", true)
    Signals.player_message.emit("Daniel", "Sure thing, boss, I'm heading to them now.", true)

func _second_dialog() -> void:
    Signals.save_game.emit()
    Signals.save_to_file.emit()
    Signals.show_dialog.emit()
    Signals.people_message.emit("Przemek", "Well, our sleeping princess has finally arrived!", true)
    Signals.people_message.emit("Przemek", "What's the matter, didn't want to get out of bed?", true)
    Signals.player_message.emit("Daniel", "Oh, come on, guys, give me a break and let's get to work. I have to stay late to catch up anyway.", true)

func _on_stone_mini_game_body_entered(body:Node2D) -> void:
    if body.is_in_group("Player"):
        _second_dialog()
            

func _start_stone_mini_game() -> void:
    mini_game_is_running = true
    game = stone_mini_game.instantiate()
    game.z_index = 1
    game.global_position = mini_game_pos.global_position
    add_child(game)
    $PhantomCamera2D.follow_target = game
    _player.hide()
    State.is_running = false