extends Node
class_name LevelManager

@export var levels: Array[PackedScene] = []
@export var current_level_index: int = 0

var current_level: Node = null

func _ready():
	load_level(current_level_index)

func load_level(level_index: int):
	# Sprawdź czy index jest poprawny
	if level_index < 0 or level_index >= levels.size():
		push_error("Invalid level index: " + str(level_index))
		return

	# Usuń obecny poziom jeśli istnieje
	if current_level:
		current_level.queue_free()
		await current_level.tree_exited

	# Załaduj nowy poziom
	var level_scene = levels[level_index]
	if level_scene:
		current_level = level_scene.instantiate()
		add_child(current_level)
		current_level_index = level_index

		# Poinformuj że poziom został załadowany
		Signals.level_loaded.emit(current_level_index)
	else:
		push_error("Invalid level scene at index: " + str(level_index))

func next_level():
	if current_level_index + 1 < levels.size():
		load_level(current_level_index + 1)
	else:
		# Ostatni poziom - możesz tu dodać ekran końcowy
		Signals.game_completed.emit()

func restart_level():
	load_level(current_level_index)

# Funkcja do przejścia do konkretnego poziomu
func goto_level(level_index: int):
	if level_index >= 0 and level_index < levels.size():
		load_level(level_index)