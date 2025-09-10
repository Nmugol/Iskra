extends Node2D


@export var player: Player

@export_category("NPC")
@export var emil: NPC
@export var miriam: NPC

@export_category("NPC path")
@export var miriam_path: PathController
@export var emil_path: PathController

@export_category("State 13")
@export var player_pos: Vector2

func _ready() -> void:

    if State.state_number == 13:
        emil.show()
        miriam.show()

        player.navigation.target_position = player_pos
        player.global_position = player_pos

func _process(_delta: float) -> void:
    if not State.is_running or State.is_loading:
        return