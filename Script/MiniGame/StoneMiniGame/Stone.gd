@tool
class_name Stone
extends CharacterBody2D

@export var id: int

enum StoneSize {
	SMALL,
	LARGE_VERTICAL,
	LARGE_HORIZONTAL,
	BIG,
}

var sprite_size_small: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_small.png")
var sprite_size_large_vertical: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_large_vertical.png")
var sprite_size_large_horizontal: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_large_horizontal.png")
var sprite_size_big: CompressedTexture2D = preload("res://Sprite/StoneMiniGame/stone_big.png")

@export var sprite: Sprite2D
@export var collision: CollisionShape2D
@export var logical_collision: CollisionShape2D

@export var size: StoneSize = StoneSize.SMALL:
	set(value):
		size = value
		update_sprite()

var vel: Vector2 = Vector2.ZERO
var is_moving: bool = false

const SPEED: int = 100


func update_sprite() -> void:
	match size:
		StoneSize.SMALL:
			sprite.texture = sprite_size_small
			collision.shape.size = Vector2(30, 30)
			logical_collision.shape.size = Vector2(31, 31)
		StoneSize.LARGE_VERTICAL:
			sprite.texture = sprite_size_large_vertical
			collision.shape.size = Vector2(30, 62)
			logical_collision.shape.size = Vector2(31, 63)
		StoneSize.LARGE_HORIZONTAL:
			sprite.texture = sprite_size_large_horizontal
			collision.shape.size = Vector2(62, 30)
			logical_collision.shape.size = Vector2(63, 31)
		StoneSize.BIG:
			sprite.texture = sprite_size_big
			collision.shape.size = Vector2(62, 62)
			logical_collision.shape.size = Vector2(63, 63)


func _ready() -> void:
	Signals.move_stone.connect(_on_move_stone)

	update_sprite()

	# KONFIGURACJA KOLIZJI - kamienie wykrywają się nawzajem
	collision_layer = 2 # Kamienie są na warstwie 2
	collision_mask = 2 # Kamienie wykrywają kolizje z warstwą 2 (inne kamienie)

	# Dodaj do grupy Stone dla łatwej identyfikacji
	add_to_group("Stone")


func _physics_process(delta: float) -> void:
	if is_moving and vel != Vector2.ZERO:
		velocity = vel * SPEED
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			var collider = collision_info.get_collider()
			# Sprawdź czy kolizja jest z innym kamieniem
			if collider and collider.is_in_group("Stone"):
				_stop_movement()


func _on_move_stone(v: Vector2, s: int) -> void:
	if s == id:
		vel = v
		is_moving = true


func _stop_movement() -> void:
	is_moving = false
	velocity = Vector2.ZERO
	position -= vel.normalized()
	vel = Vector2.ZERO
	Signals.stone_not_moving.emit(id)
