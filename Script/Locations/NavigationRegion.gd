extends Node2D

@onready var navigation: NavigationRegion2D = $NavigationRegion2D
@onready var collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@export var collision_area: CollisionPolygon2D



func _ready() -> void:
	show()
	
	# Utwórz nowy NavigationPolygon i dodaj kontur
	var navigation_polygon = NavigationPolygon.new()
	navigation_polygon.add_outline(collision_area.polygon)
	
	# Ustaw tymczasowy polygon w regionie
	navigation.navigation_polygon = navigation_polygon
	
	# Użyj serwera nawigacji do wypieczenie polygon
	navigation.bake_navigation_polygon(false)  # Argument 'true' dla synchronicznego pieczenia
	
	# Ustaw kolizję
	collision.polygon = collision_area.polygon



func _on_area_2d_mouse_entered() -> void:
	State.is_running = true
	Signals.set_cursor.emit(State.Cursors.WALK)


func _on_area_2d_mouse_exited() -> void:
	State.is_running = false
	Signals.reset_cursor.emit()
