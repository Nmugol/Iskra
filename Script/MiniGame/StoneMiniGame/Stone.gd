@tool
class_name Stone
extends CharacterBody2D 

@export var id: int

enum StoneSize{
	SMALL,
	LARGE_VERTICAL,
	LARGE_HORIZONTAL,
	BIG
}

var sprite_size_small: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_small.png")
var sprite_size_large_vertical: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_large_vertical.png")
var sprite_size_large_horizontal: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_large_horizontal.png")
var sprite_size_big: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_big.png")

@export var sprite: Sprite2D 
@export var collision: CollisionShape2D
@export var logical_collision: CollisionShape2D
@export var detection_area: Area2D  # Referencja do Area2D

@export var size: StoneSize = StoneSize.SMALL:
	set(value):
		size = value
		
		match size:
			StoneSize.SMALL:
				sprite.texture = sprite_size_small
				collision.shape.size = Vector2(30,30)
				logical_collision.shape.size = Vector2(32,32)
			StoneSize.LARGE_VERTICAL:
				sprite.texture = sprite_size_large_vertical
				collision.shape.size = Vector2(30,62)
				logical_collision.shape.size = Vector2(32,64)
			StoneSize.LARGE_HORIZONTAL:
				sprite.texture = sprite_size_large_horizontal
				collision.shape.size = Vector2(62,30)
				logical_collision.shape.size = Vector2(64,32)
			StoneSize.BIG:
				sprite.texture = sprite_size_big
				collision.shape.size = Vector2(62,62)
				logical_collision.shape.size = Vector2(64,64)

var vel: Vector2 = Vector2.ZERO
var is_moving: bool = false

const SPEED: int = 100

func _ready() -> void:
	Signals.move_stone.connect(_on_move_stone)
	
	# KONFIGURACJA AREA2D
	if detection_area:
		# Użyj area_entered zamiast body_entered dla Area2D
		detection_area.area_entered.connect(_on_area_entered)
		detection_area.body_entered.connect(_on_body_entered)
		
		# Konfiguracja warstw kolizji
		detection_area.collision_mask = 1  # Wykrywa obiekty na warstwie 1
		detection_area.collision_layer = 2  # Sam jest na warstwie 2
		
		# CharacterBody2D też musi mieć ustawione warstwy
		collision_layer = 1  # Kamienie są na warstwie 1
		collision_mask = 0   # Nie wykrywa kolizji z innymi CharacterBody2D

func _physics_process(delta: float) -> void:
	if is_moving and vel != Vector2.ZERO:
		velocity = vel * SPEED
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			# Kolizja wykryta przez move_and_collide
			_handle_collision(collision_info.get_collider())

func _on_move_stone(v: Vector2, s: int) -> void:
	if s == id:
		vel = v
		is_moving = true

func _on_area_entered(area: Area2D) -> void:
	# Wykrywa wejście innego Area2D (z innych kamieni)
	if area.get_parent().is_in_group("Stone"):
		print("Area collision with stone")
		_stop_movement()

func _on_body_entered(body: Node2D) -> void:
	# Wykrywa wejście Body (CharacterBody2D, RigidBody2D)
	if body.is_in_group("Stone"):
		print("Body collision with stone")
		_stop_movement()

func _handle_collision(collider: Node) -> void:
	# Obsługa kolizji z move_and_collide
	if collider.is_in_group("Stone"):
		print("Move_and_collide detected stone")
		_stop_movement()

func _stop_movement() -> void:
	velocity = Vector2.ZERO
	vel = Vector2.ZERO
	is_moving = false
	Signals.stone_not_moving.emit(id)
