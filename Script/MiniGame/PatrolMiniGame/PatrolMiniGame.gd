extends Node2D

@export_category("Player start points")
@export var player_start_points: Array[StopPoint] = []

@export_category("Patrol start points")
@export var patrol_start_points: Array[StopPoint] = []

@onready var level_loader_node: Node2D = $StopPoints

var level_1: PackedScene = preload("res://Scenes/MiniGame/PatrolMiniGame/level_1.tscn")
var level_2: PackedScene = preload("res://Scenes/MiniGame/PatrolMiniGame/level_2.tscn")
var level_3: PackedScene = preload("res://Scenes/MiniGame/PatrolMiniGame/level_3.tscn")

var current_level: int = 1


func _ready() -> void:
	level_loader()
	connect_signals()


func connect_signals() -> void:
	Signals.reset_level.connect(reset_level)
	Signals.next_level.connect(
		func():
			current_level += 1
			level_loader()
	)


func level_loader() -> void:
	for c in level_loader_node.get_children():
		c.queue_free()

	var level: Node = null

	match current_level:
		1:
			level = level_1.instantiate()
		2:
			level = level_2.instantiate()
		3:
			level = level_3.instantiate()
		4:
			Signals.finish_patrol_game.emit()

	if level != null:
		level_loader_node.add_child(level)

	# Zresetuj pozycję gracza po załadowaniu poziomu
	await get_tree().create_timer(0.1).timeout


func reset_level() -> void:
	# Najpierw wyślij sygnał resetu do wszystkich punktów
	print("Reset level")
	#Signals.reset_level.emit()

	# Poczekaj chwilę żeby punkty się zresetowały
	await get_tree().create_timer(0.1).timeout

	# Dopiero potem załaduj poziom
	level_loader()
