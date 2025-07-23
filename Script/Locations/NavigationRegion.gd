extends Node2D

@onready var Navigation: NavigationRegion2D = $NavigationRegion2D
@onready var Collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@export var CollisionArea: CollisionPolygon2D



func _ready() -> void:
	show()
	
	# Utwórz nowy NavigationPolygon i dodaj kontur
	var navigation_polygon = NavigationPolygon.new()
	navigation_polygon.add_outline(CollisionArea.polygon)
	
	# Ustaw tymczasowy polygon w regionie
	Navigation.navigation_polygon = navigation_polygon
	
	# Użyj serwera nawigacji do upieczenia polygonu
	Navigation.bake_navigation_polygon(false)  # Argument 'true' dla synchronicznego pieczenia
	
	# Ustaw kolizję
	Collision.polygon = CollisionArea.polygon



func _on_area_2d_mouse_entered() -> void:
	State.IsInArea = true
	Signals.set_coursor.emit(State.Coursors.WALK)


func _on_area_2d_mouse_exited() -> void:
	State.IsInArea = false
	Signals.reset_coursor.emit()
