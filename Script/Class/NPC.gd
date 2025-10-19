@tool
class_name NPC
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum Npc_names{
	EMIL_SCHMIDT,
	MIRIAM_SCHMIDT,
	JAMES,
	JONAS,
	ZYGMUNT,
	PETER,
	GUARD_1,
	GUARD_2,
	GUARD_3,
	GUARD_4,
	GUARD_5,
	GUARD_6,
	GUARD_7,
	GUARD_8,
	HANIA,
	KACPER,
	KAMILA,
	PATRYK,
	PRZEMEK,
	NPC_1,
	NPC_2,
	NPC_3,
	NPC_4,
	NPC_5,
	NPC_6,
	NPC_7,
	NPC_8,
	NPC_9,
}
@export var npc_name: Npc_names = Npc_names.GUARD_1:
	set(value):
		npc_name = value
		update_animation()
	get: return npc_name

enum  Animation_names{
	IDLE, WALK, UP, DOWN
}

@export var animation_name: Animation_names = Animation_names.IDLE:
	set(value):
		animation_name = value
		update_animation()

@export var flip_sprite: bool = false:
	set(value):
		flip_sprite = value
		update_flip()
	get: return flip_sprite

func update_state(anim: String, flip: bool):
	animation_name = Animation_names[anim.to_upper()]
	flip_sprite = flip

func update_animation():
	if not is_instance_valid(sprite) or not sprite.sprite_frames:
		return  # Zabezpieczenie przed dostępem do niezainicjowanego węzła
	
	var animation_character: String = Npc_names.keys()[Npc_names.values().find(npc_name)]
	var animation_typ: String = Animation_names.keys()[Animation_names.values().find(animation_name)]
	var target_animation = "%s_%s" % [animation_character.capitalize().replace(" ","_"), animation_typ.capitalize()]
	
	if sprite.sprite_frames.has_animation(target_animation):
		
		match animation_name:
			Animation_names.IDLE: 
				sprite.scale = Vector2(0.5, 0.5)
			Animation_names.WALK: 
				sprite.scale = Vector2(0.667, 0.667)
		sprite.play(str(target_animation))

func update_flip():
	if is_instance_valid(sprite):
		sprite.flip_h = flip_sprite

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	update_animation()
	update_flip()
