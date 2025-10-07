class_name MovingArrow
extends Area2D

@export_category("Sprite")
@export var sprite: Sprite2D

@export_category("moving")
@export var stone_to_move: Stone
@export var velocity: Vector2

var is_active: bool = true
var mouse_on: bool = false

func _ready() -> void:
	sprite.hide()
	
	self.mouse_entered.connect(_on_mouse_entered)
	self.mouse_exited.connect(_on_mouse_exited)
	
	Signals.move_stone.connect(
		func(_v: Vector2, _s: int) -> void:  # Dodane parametry
			is_active = false
	)
	
	Signals.stone_not_moving.connect(func() -> void: is_active = true)

func _process(delta: float) -> void:
	if is_active and mouse_on and Input.is_action_just_pressed("MovePlayer"):
		# WYSYŁAMY SYGNAŁ TYLKO DLA KONKRETNEGO KAMIENIA
		Signals.move_stone.emit(velocity, stone_to_move.id)

func _on_mouse_entered() -> void:
	if not is_active: 
		return
	mouse_on = true
	sprite.show()

func _on_mouse_exited() -> void:
	mouse_on = false
	sprite.hide()
