extends Node2D

@onready var Navigation: NavigationRegion2D = $NavigationRegion2D
@onready var Collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@export var CollisionArea: CollisionPolygon2D



func _ready() -> void:
	show()
	var navigation_polygon = NavigationPolygon.new()
	navigation_polygon.add_outline(CollisionArea.polygon)
	navigation_polygon.make_polygons_from_outlines()
	
	Navigation.navigation_polygon = navigation_polygon
	Collision.polygon = CollisionArea.polygon



func _on_area_2d_mouse_entered() -> void:
	State.IsInArea = true
	Signals.set_coursor.emit(State.Coursors.WALK)


func _on_area_2d_mouse_exited() -> void:
	State.IsInArea = false
	Signals.reset_coursor.emit()
