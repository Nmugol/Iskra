extends Path2D

class_name PathController

@export_group("Path settings")
@export var path: PathFollow2D
@export var stop_points: float = 1.0
@export var speed: float = 0.1
@export var active: bool = false

@export_group("NPC settings")
@export var npc: NPC
@export var flip_sprite_on_end: bool = false

var previous_pos: Vector2
var current_pos: Vector2


func _process(delta: float) -> void:
	if not active:
		return
	path.progress_ratio = move_toward(path.progress_ratio, stop_points, speed * delta)

	current_pos = npc.global_position

	var delta_pos: Vector2 = current_pos - previous_pos

	if abs(delta_pos.x) > abs(delta_pos.y):
		if delta_pos.x > 0:
			npc.update_state("Walk", false)
		else:
			npc.update_state("Walk", true)
	else:
		if delta_pos.y > 0:
			npc.update_state("Down", false)
		else:
			npc.update_state("Up", false)

	previous_pos = current_pos

	if abs(path.progress_ratio - stop_points) <= 0.01:
		path.progress_ratio = stop_points
		npc.update_state("idle", flip_sprite_on_end)
		active = false


func _play() -> void:
	previous_pos = npc.global_position
	current_pos = npc.global_position
	active = true


func _finish_play() -> void:
	path.progress_ratio = 1
	active = false
