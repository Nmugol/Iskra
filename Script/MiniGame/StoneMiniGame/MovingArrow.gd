class_name MovingArrow
extends Area2D

@export var disabe_area: Area2D

@export_category("Sprite")
@export var sprite: Sprite2D

@export_category("moving")
@export var stone_to_move: Stone
@export var velocity: Vector2

var is_active: bool = true
var is_blocked: bool = false
var mouse_on: bool = false

func _ready() -> void:
	sprite.hide()
	
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	Signals.move_stone.connect(_on_move_stone)
	
	Signals.stone_not_moving.connect(_on_stone_not_moving)
	
	# Konfiguracja warstw kolizji dla disable_area
	disabe_area.collision_mask = 1  # Wykrywa kamienie na warstwie 1
	disabe_area.collision_layer = 0  # Nie musi być na żadnej warstwie
	
	# Sprawdzamy czy już są obiekty w kolizji przy starcie
	_update_blocked_state()
	
	disabe_area.area_entered.connect(
		func(_area) -> void:
			call_deferred("_update_blocked_state")
	)
			
	disabe_area.area_exited.connect(
		func(_area) -> void:
			call_deferred("_update_blocked_state")
	)
	
	disabe_area.body_entered.connect(
		func(_body) -> void:
			call_deferred("_update_blocked_state")
	)
			
	disabe_area.body_exited.connect(
		func(_body) -> void:
			call_deferred("_update_blocked_state")
	)

func _on_move_stone(move_velocity: Vector2, moved_stone_id: int) -> void:
	# Wyłączamy TYLKO strzałki przypisane do ruchomego kamienia
	if moved_stone_id == stone_to_move.id:
		is_active = false
		sprite.hide()

func _on_stone_not_moving(stopped_stone_id: int) -> void:
	# Aktywujemy WSZYSTKIE strzałki gdy jakikolwiek kamień się zatrzyma
	# (każda strzałka i tak sprawdzi czy jest zablokowana)
	is_active = true
	# Odraczamy sprawdzenie stanu, aby kolizje były aktualne
	call_deferred("_update_blocked_state")

func _update_blocked_state() -> void:
	# Sprawdzamy zarówno bodies jak i areas w kolizji
	var overlapping_bodies = disabe_area.get_overlapping_bodies()
	var overlapping_areas = disabe_area.get_overlapping_areas()
	
	# Sprawdzamy czy którykolwiek z wykrytych obiektów jest kamieniem (ale nie tym, do którego jest przypisana strzałka)
	var has_stone = false
	
	for body in overlapping_bodies:
		if body.is_in_group("Stone") and body != stone_to_move:
			has_stone = true
			break
	
	for area in overlapping_areas:
		var parent = area.get_parent()
		if parent and parent.is_in_group("Stone") and parent != stone_to_move:
			has_stone = true
			break
	
	is_blocked = has_stone
	
	# Debug info
	print("Arrow for stone ", stone_to_move.id, " - is_active: ", is_active, " is_blocked: ", is_blocked, " mouse_on: ", mouse_on)
	
	# Aktualizujemy wygląd strzałki
	_update_sprite_visibility()

func _update_sprite_visibility() -> void:
	if is_active and not is_blocked and mouse_on:
		sprite.show()
	else:
		sprite.hide()

func _process(delta: float) -> void:
	if is_active and not is_blocked and mouse_on and Input.is_action_just_pressed("MovePlayer"):
		Signals.move_stone.emit(velocity, stone_to_move.id)

func _on_mouse_entered() -> void:
	if not is_active or is_blocked: 
		return
	mouse_on = true
	_update_sprite_visibility()

func _on_mouse_exited() -> void:
	mouse_on = false
	_update_sprite_visibility()
