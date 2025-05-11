@tool
class_name NPC
extends CharacterBody2D

@export_enum(
	"EmilSchmidt", 
	"MiriamSchmidt", 
	"James", 
	"Jonas",  
	"Zygmunt", 
	"Peter",
	"Guards",
	"Hania",
	"Kacper",
	"Kamila",
	"Patryk",
	"Przemek"
	) var npc_name: String = "Guards":
		set(value):
			npc_name = value
			animation_to_play = npc_name+"_"+animation_name
			
			sprite.play(animation_to_play)
	
		get: return npc_name
	
@export_enum(
	"Idle", 
	"Walk"
	) var animation_name: String = "Idle":
	set(value):
		animation_name = value
		animation_to_play = npc_name+"_"+animation_name
		
		sprite.play(animation_to_play)
		
		match value:
			"Idle": sprite.scale = Vector2(0.5,0.5)
			"Walk": sprite.scale = Vector2(0.667,0.667)
			
		
	get: return animation_name

@export var flip_sprite: bool = false:
	set(value):
		flip_sprite = value
		
		sprite.flip_h = value
	get: return flip_sprite

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var animation_to_play: String = ""



func _ready() -> void:
	sprite.play(animation_to_play)
	match animation_name:
			"Idle": sprite.scale = Vector2(0.5,0.5)
			"Walk": sprite.scale = Vector2(0.667,0.667)

func _process(_delta: float) -> void:
	if flip_sprite:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
