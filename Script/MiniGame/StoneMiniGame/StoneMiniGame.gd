extends Node2D

var level_1: PackedScene = preload("res://Scenes/MiniGame/StoneMiniGame/level_1.tscn")
var level_2: PackedScene = preload("res://Scenes/MiniGame/StoneMiniGame/level_2.tscn")
var level_3: PackedScene = preload("res://Scenes/MiniGame/StoneMiniGame/level_3.tscn")

var current_level: int = 1

@export_category("Level loader")
@export var level_position: Node2D

@export_category("Player")
@export var path_to_follow: PathFollow2D
@export var detect_area: Area2D
@export var daniel_zone: StaticBody2D

var daniel_is_moving: bool = false

func _ready() -> void:
	level_loader()
	

func _process(_delta: float) -> void:
	if not daniel_is_moving: return

	path_to_follow.progress_ratio += 0.01

	if path_to_follow.progress_ratio >= 0.96:  # Changed to avoid floating point precision issues
		daniel_is_moving = false
		current_level += 1
		detect_area.set_deferred("monitoring", false)
		path_to_follow.progress_ratio = 0
		level_loader()

func level_loader() -> void:
	daniel_zone.show()
	detect_area.hide()
	for c in level_position.get_children(): 
		c.queue_free()
	
	match current_level:
		1:
			var level_1_instance = level_1.instantiate()
			level_position.add_child(level_1_instance)
		2:
			var level_2_instance = level_2.instantiate()
			level_position.add_child(level_2_instance)
		3:
			var level_3_instance = level_3.instantiate()
			level_position.add_child(level_3_instance)
		4:
			Signals.finish_stone_min_game.emit()
			self.queue_free()
			
	path_to_follow.progress_ratio = 0
	call_deferred("_deferred_disable_monitoring")
	daniel_is_moving = false

func _deferred_disable_monitoring() -> void:
	detect_area.monitoring = false


func _on_play_pressed() -> void:
	daniel_zone.hide()
	await get_tree().create_timer(0.5).timeout
	daniel_is_moving = true
	detect_area.show()
	call_deferred("_deferred_enable_monitoring")

func _deferred_enable_monitoring() -> void:
	detect_area.monitoring = true


func _on_reset_pressed() -> void:
	level_loader()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if daniel_is_moving and body.is_in_group("Stone"):
		# Use call_deferred to safely call level_loader
		call_deferred("level_loader")
