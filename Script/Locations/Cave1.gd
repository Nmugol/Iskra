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
                1:
                    supervisor.show()
        22:
            match State.state_phase:
                2:
                    _start_stone_mini_game()
        _:
            supervisor.hide()

func _connect_signals()->void:
    Signals.finish_stone_min_game.connect(_finish_stone_mini_game)

func _process(_delta: float) -> void:
    print("State number: ", State.state_number, " State phase: ", State.state_phase)
    if mini_game_is_running or State.is_loading: return

    match State.state_number:
        21:
            match State.state_phase:
                1:
                    _first_dialog()
                4:
                    dialog_is_running = false
                    Signals.change_info_panel_text.emit("Go to the crew and start clearing the stones from the tunnel.")
                    Signals.change_info_panel_visibility.emit(true)
                    State.state_number = 22
                    State.state_phase = 0
        22:
            match State.state_phase:
                3:
                    if game == null:
                        _start_stone_mini_game()
        23:
            match State.state_phase:
                0:
                    supervisor.position = Vector2(1272,584)
                    supervisor.show()
                    _player.position = Vector2(1208,600)
                    _player.navigation.target_position = Vector2(1208,600)


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
    Signals.people_message.emit("NPC_6", "Well, our sleeping princess has finally arrived!", true)
    Signals.people_message.emit("NPC_2", "What's the matter, didn't want to get out of bed?", true)
    Signals.player_message.emit("Daniel", "Oh, come on, guys, give me a break and let's get to work. I have to stay late to catch up anyway.", true)

func _third_dialogue() -> void:
    Signals.save_game.emit()
    Signals.people_message.emit("Przemek", "The lads let me know you've finished.", true)
    Signals.people_message.emit("Przemek", "Kid, I'm feeling generous, so go home already.", true)
    Signals.player_message.emit("Daniel", "But I have to make up for being late.", true)
    Signals.people_message.emit("Przemek", "Let's put it this way: I'll turn a blind eye to you being late, because I'm in a hurry today myself. It's my anniversary with my wife.", true)
    Signals.player_message.emit("Daniel", "Wow, thanks, boss. You're the best!", true)
    Signals.people_message.emit("Przemek", "But remember, just this one time.", true)
    

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

func _finish_stone_mini_game() -> void:
    $PhantomCamera2D.follow_target = _player
    mini_game_is_running = false
    _player.show()

    State.state_number = 23
    State.state_phase = 0

    Signals.save_game.emit()
    Signals.save_to_file.emit()
    State.is_running = true
