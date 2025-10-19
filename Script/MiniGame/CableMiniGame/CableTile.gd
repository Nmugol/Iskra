extends Node2D
class_name CableTile

enum CableType {
	STRAIGHT,     # 0
	CORNER_L,     # 1
	CORNER_R,     # 2
	CROSS,        # 3
	T_JUNCTION,   # 4
	DUAL_CORNER   # 5
}

const UP = Vector2i(0, -1)
const DOWN = Vector2i(0, 1)
const LEFT = Vector2i(-1, 0)
const RIGHT = Vector2i(1, 0)

const CONNECTION_MAP = {
	CableType.STRAIGHT: [[UP, DOWN], [LEFT, RIGHT], [DOWN, UP], [RIGHT, LEFT]],
	CableType.CORNER_L: [[DOWN, LEFT], [LEFT, UP], [UP, RIGHT], [RIGHT, DOWN]],
	CableType.CORNER_R: [[DOWN, RIGHT], [DOWN, LEFT], [UP, LEFT], [UP, RIGHT]],
	CableType.CROSS: [[UP, DOWN, LEFT, RIGHT], [UP, DOWN, LEFT, RIGHT], [UP, DOWN, LEFT, RIGHT], [UP, DOWN, LEFT, RIGHT]],
	CableType.T_JUNCTION: [[DOWN, LEFT, RIGHT], [UP, DOWN, LEFT], [UP, LEFT, RIGHT], [UP, DOWN, RIGHT]], 
}

const DUAL_CORNER_LOGIC = {
	0: {UP: [RIGHT], RIGHT: [UP], DOWN: [LEFT], LEFT: [DOWN]},
	1: {RIGHT: [DOWN], DOWN: [RIGHT], UP: [LEFT], LEFT: [UP]},
	2: { DOWN: [LEFT], UP: [RIGHT], LEFT: [DOWN], RIGHT: [UP]},
	3: {LEFT: [UP], UP: [LEFT], RIGHT: [DOWN], DOWN: [RIGHT]}
}

@export_category("Type")
@export var cable_type: CableType = CableType.STRAIGHT:
	set(value):
		cable_type = value
		if sprite:
			sprite.play(CableType.keys()[int(cable_type)])
	get():
		return cable_type

@export_category("Sprite")
@export var sprite: AnimatedSprite2D
@export_range(0,3,1) var rotation_step: int = 0
@export var bg: AnimatedSprite2D

@export_category("Light")
@export var BotomLeft: PointLight2D
@export var UpRight: PointLight2D
@export var DefaultLight: PointLight2D

@export_category("Position")
@export var grid_position: Vector2i = Vector2i.ZERO

var neighbors_powered_from: Array[Vector2i] = []
var is_powered: bool = false
var game_is_start: bool = false

var is_target_or_source: bool = false

func _ready() -> void:
	set_power_state(false, [])

func set_bg()->void:
	if is_target_or_source:
		bg.show()
		if is_powered:
			bg.play("Active")
		else:
			bg.play("Deactivated")
	else:
		bg.hide()

func rotation_tile()->void:
	rotation_step = (rotation_step + 1) % 4
	sprite.rotation_degrees = rotation_step * 90
	Signals.tile_rotated.emit(grid_position)

func get_output_dir(incoming_dir: Vector2i = Vector2i.ZERO):
	if cable_type == CableType.DUAL_CORNER:
		var paths = DUAL_CORNER_LOGIC.get(rotation_step, {})
		if incoming_dir == Vector2i.ZERO:
			return [UP, DOWN, LEFT, RIGHT] as Array[Vector2i]
		return paths.get(incoming_dir, []) as Array[Vector2i]
	if rotation_step < 0 or rotation_step >= 4: 
		return [] as Array[Vector2i]
	
	var type_map = CONNECTION_MAP.get(cable_type)
	if type_map == null: return [] as Array[Vector2i]
	
	var all_open_ports = type_map[rotation_step]
	if incoming_dir != Vector2i.ZERO and all_open_ports.has(incoming_dir):
		var output = all_open_ports.duplicate()
		output.erase(incoming_dir)
		return output
		
	return all_open_ports

func set_power_state(powered: bool, powered_from: Array[Vector2i]) -> void:
	is_powered = powered
	neighbors_powered_from = powered_from
	
	set_bg()

	if is_instance_valid(UpRight): UpRight.hide()
	if is_instance_valid(BotomLeft): BotomLeft.hide()
	if is_instance_valid(DefaultLight): DefaultLight.hide()

	if not is_powered:
		return

	if cable_type != CableType.DUAL_CORNER:
		if is_instance_valid(DefaultLight): DefaultLight.show()
		return

	var upright_light_active = false
	var bottomleft_light_active = false
	
	for incoming_dir in powered_from:
		
		match rotation_step:
			0:
				if incoming_dir == UP or incoming_dir == RIGHT:
					upright_light_active = true
				if incoming_dir == DOWN or incoming_dir == LEFT:
					bottomleft_light_active = true
			1:
				if incoming_dir == RIGHT or incoming_dir == DOWN:
					upright_light_active = true
				if incoming_dir == UP or incoming_dir == LEFT:
					bottomleft_light_active = true
			2:
				if incoming_dir == UP or incoming_dir == RIGHT:
					bottomleft_light_active = true 
				if incoming_dir == DOWN or incoming_dir == LEFT:
					upright_light_active = true
			3:
				if incoming_dir == UP or incoming_dir == LEFT:
					upright_light_active = true
				if incoming_dir == DOWN or incoming_dir == RIGHT:
					bottomleft_light_active = true

	if upright_light_active and is_instance_valid(UpRight):
		UpRight.show()
		
	if bottomleft_light_active and is_instance_valid(BotomLeft):
		BotomLeft.show()
		
	if upright_light_active and bottomleft_light_active and is_instance_valid(DefaultLight):
		DefaultLight.show()

func _on_area_2d_input_event(_viewport:Node, event:InputEvent, _shape_idx:int) -> void:
	if game_is_start or is_target_or_source: return 
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		rotation_tile()
