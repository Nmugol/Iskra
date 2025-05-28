extends Node2D

@onready var Navigation: NavigationRegion2D = $NavigationRegion2D
@onready var Collision: CollisionPolygon2D = $Area2D/CollisionPolygon2D
@export var CollisionArea: CollisionPolygon2D

func _ready() -> void:
	show()
	var new_navigation_mesh = NavigationPolygon.new()
	var bounding_outline: PackedVector2Array = CollisionArea.polygon
	new_navigation_mesh.add_outline(bounding_outline)
	NavigationServer2D.bake_from_source_geometry_data(new_navigation_mesh, NavigationMeshSourceGeometryData2D.new());
	Navigation.navigation_polygon = new_navigation_mesh
	
	Collision.polygon = CollisionArea.polygon



func _on_area_2d_mouse_entered() -> void:
	State.IsInArea = true
	Signals.set_coursor.emit(State.Coursors.WALK)


func _on_area_2d_mouse_exited() -> void:
	State.IsInArea = false
	Signals.reset_coursor.emit()
