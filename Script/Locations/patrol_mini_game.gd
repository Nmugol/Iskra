extends Node2D

@onready var level1: Node2D = $StopPoints/Level1
@onready var level2: Node2D = $StopPoints/Level2
@onready var level3: Node2D = $StopPoints/Level3

func _ready() -> void:
	
	level1.show()
	level2.hide()
	level3.hide()


	drawing_path(level1)

func drawing_path(level: Node2D) -> void:
	var points: Array[Node] =         level.find_children("*", "StopPoint", false, false)
	var all_connections: Dictionary = {}

	for point in points:
		for neighbor in point.neighbor_point:
			var pair: Array[StopPoint] = [point, neighbor]
			# Używamy sort_custom do sortowania na podstawie nazw węzłów
			pair.sort_custom(func(a, b): return a.name < b.name)

			# Tworzymy unikalny klucz ze stringów, aby go zahasować
			var key: String = "%s-%s" % [pair[0].name, pair[1].name]

			# Przypisujemy parę jako wartość, używając stringowego klucza do deduplikacji
			all_connections[key] = pair

	# Iterujemy po wartościach słownika, które zawierają unikalne pary
	for connection_pair in all_connections.values():
		var line: Line2D = Line2D.new()
		var start_point: StopPoint = connection_pair[0]
		var end_point: StopPoint = connection_pair[1]

		# Rysujemy linię, używając globalnych pozycji i odejmując pozycję rodzica
		line.add_point(start_point.global_position - level.global_position)
		line.add_point(end_point.global_position - level.global_position)
		line.width = 5
		line.default_color = Color(0.6392157, 0.19215687, 0.19215687)

		level.add_child(line)
