extends Path2D
class_name PathControler

@export var path: PathFollow2D
@export var stop_points: Array[float] = []
@export var speed: float = 0.1
var NPC_arrey: Array[NPC] = []

var current_stop_point: int = 0
var is_active: bool = false

func _updet_NPC_arrey() -> void:
	for c in path.get_children():
		if c is NPC:
			NPC_arrey.append(c)

func _process(delta: float) -> void:
	if not is_active: return
	
	path.progress_ratio = move_toward(path.progress_ratio, current_stop_point, speed*delta)
	if abs(path.progress_ratio - stop_points[current_stop_point]) < 0.001:
		path.progress_ratio = stop_points[current_stop_point]
		current_stop_point += 1
		for npc in NPC_arrey :
			npc.animation_name = npc.animation_mames["IDLE"]
		is_active = false
	
