@tool
class_name NPC
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum npc_names{
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
	PRZEMEK
}
@export var npc_name: npc_names = npc_names.GUARD_1:
	set(value):
		npc_name = value
		update_animation()
	get: return npc_name

enum  animation_mames{
	IDLE, WALK
}

@export var animation_name: animation_mames = animation_mames.IDLE:
	set(value):
		animation_name = value
		update_animation()

@export var flip_sprite: bool = false:
	set(value):
		flip_sprite = value
		update_flip()
	get: return flip_sprite

func setup(anim: String, flip: bool):
	animation_name = animation_mames[anim.to_upper()]
	flip_sprite = flip

func update_state(anim: String, flip: bool):
	animation_name = animation_mames[anim.to_upper()]
	flip_sprite = flip

func update_animation():
	if not is_instance_valid(sprite) or not sprite.sprite_frames:
		return  # Zabezpieczenie przed dostępem do niezainicjalizowanego węzła
	
	var ak: String = npc_names.keys()[npc_names.values().find(npc_name)]
	var ak2: String = animation_mames.keys()[animation_mames.values().find(animation_name)]
	var target_animation = "%s_%s" % [ak.capitalize().replace(" ","_"), ak2.capitalize()]
	
	if sprite.sprite_frames.has_animation(target_animation):
		
		match animation_name:
			animation_mames.IDLE: 
				sprite.scale = Vector2(0.5, 0.5)
			animation_mames.WALK: 
				sprite.scale = Vector2(0.667, 0.667)
				
		for i in 2:
			await get_tree().process_frame
	
		sprite.play(str(target_animation))
	else:
		printerr("Brak animacji: ", target_animation)

func update_flip():
	if is_instance_valid(sprite):
		sprite.flip_h = flip_sprite

func _ready() -> void:
	if Engine.is_editor_hint():
		return  # Ignoruj w edytorze
		
	# Inicjalizacja po wszystkich węzłach
	await get_tree().process_frame
	update_animation()
	update_flip()
