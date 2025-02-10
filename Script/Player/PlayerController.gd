extends CharacterBody2D

@export var speed: float = 300

var mouse_pos = Vector2()
var target_pos = Vector2()

func _ready()->void:
    Signals.connect("save_game" , SavePlayerData)
    
    SetUp()

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("MovePlayer"):
        mouse_pos = get_global_mouse_position()
        print("mouse pos: ", mouse_pos)

        Save.PlayerPosition = mouse_pos

    if position.distance_to(mouse_pos) > 3:
        target_pos = (mouse_pos-position).normalized()
        velocity = target_pos * speed
        move_and_slide()

        Signals.emit_signal("save_game")
        Signals.emit_signal("save_to_file")
    pass

func SavePlayerData()->void:
    Save.PlayerPosition = position
    Save.Equipment = []

func SetUp()->void:
    position = Save.PlayerPosition
    mouse_pos = Save.PlayerPosition
