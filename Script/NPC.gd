@tool
class_name NPC
extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@export_enum(
	"EmilSchmidt", 
	"MiriamSchmidt", 
	"James", 
	"Jonas",  
	"Zygmunt", 
	"Peter",
	"Guards1",
	"Guards2",
	"Guards3",
	"Guards4",
	"Guards5",
	"Guards6",
	"Guards7",
	"Guards8",
	"Hania",
	"Kacper",
	"Kamila",
	"Patryk",
	"Przemek"
	) var npc_name: String = "Guards":
	set(value):
		npc_name = value
		update_animation()
	get: return npc_name

@export_enum("Idle", "Walk") var animation_name: String = "Idle":
	set(value):
		animation_name = value
		update_animation()

@export var flip_sprite: bool = false:
	set(value):
		flip_sprite = value
		update_flip()
	get: return flip_sprite

func setup(anim: String, flip: bool):
	animation_name = anim
	flip_sprite = flip

func update_state(anim: String, flip: bool):
	animation_name = anim
	flip_sprite = flip

func update_animation():
	if not is_instance_valid(sprite) or not sprite.sprite_frames:
		return  # Zabezpieczenie przed dostępem do niezainicjalizowanego węzła
	
	var target_animation = "%s_%s" % [npc_name, animation_name]
	
	if sprite.sprite_frames.has_animation(target_animation):
		
		match animation_name:
			"Idle": 
				sprite.scale = Vector2(0.5, 0.5)
			"Walk": 
				sprite.scale = Vector2(0.667, 0.667)
				
		for i in 2:
			await get_tree().process_frame
	
		sprite.play(target_animation)
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
