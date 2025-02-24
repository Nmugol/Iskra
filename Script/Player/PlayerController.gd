extends CharacterBody2D

@export var speed: float = 300
@export var acceleration: float = 10
@export var stop_threshold: float = 5

@export var Navigation: NavigationAgent2D

var Region: NavigationRegion2D
var map

var mouse_pos = Vector2()

func _ready() -> void:
    Region = get_parent().get_node("%Region")
    if Region:
        map = Region.get_navigation_map()
    else:
        push_error("NavigationRegion2D not found!")

    Signals.connect("save_game", SavePlayerData)
    SetUp()

func IsPointInRegion(point: Vector2) -> bool:
    if map == null:
        return false  # Zabezpieczenie przed brakiem mapy nawigacyjnej
    
    var closest_point = NavigationServer2D.map_get_closest_point(map, point)
    return closest_point == point

func _physics_process(delta: float) -> void:
    if Input.is_action_just_pressed("MovePlayer"):
        var temp = get_global_mouse_position()
        if IsPointInRegion(temp):
            mouse_pos = temp
            Save.PlayerPosition = mouse_pos
            Navigation.target_position = mouse_pos

    if position.distance_to(mouse_pos) > stop_threshold:
        var direction = (Navigation.get_next_path_position() - global_position).normalized()
        velocity = velocity.lerp(direction * speed, acceleration * delta)

        Signals.emit_signal("save_game")
        Signals.emit_signal("save_to_file")
    else:
        velocity = Vector2.ZERO  # Zatrzymanie postaci
    
    move_and_slide()

func SavePlayerData() -> void:
    Save.PlayerPosition = position
    Save.Equipment = []

func SetUp() -> void:
    position = Save.PlayerPosition
    mouse_pos = Save.PlayerPosition
