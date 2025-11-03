extends Node2D

class_name AchievementZone

enum AchievementTypes {
	BOOKS,
	POSTER,
}

@export_category("Information")
@export var id: int = 0
@export var type: AchievementTypes = AchievementTypes.BOOKS

@export_category("Particle")
@export var particle: GPUParticles2D

var player_in_detection_area: bool = false


func _ready() -> void:
	match type:
		AchievementTypes.BOOKS:
			if State.pick_up_books.has(id):
				self.queue_free()
		AchievementTypes.POSTER:
			if State.pick_up_poster.has(id):
				self.queue_free()


func _on_pick_up_input_event(_viewport: Node, _event: InputEvent, _shape_idx: int) -> void:
	if player_in_detection_area and Input.is_action_just_pressed("MovePlayer"):
		match type:
			AchievementTypes.BOOKS:
				State.pick_up_books.append(id)
				if State.pick_up_books.size() == State.ALL_BOOKS_COUNT:
					State.pick_up_all_book = true
					Signals.pick_up_all_book.emit()
			AchievementTypes.POSTER:
				State.pick_up_poster.append(id)
				if State.pick_up_poster.size() == State.ALL_POSTER_COUNT:
					State.pick_up_all_poster = true
					Signals.pick_up_all_posters.emit()
	Signals.save_game.emit()
	Signals.save_to_file.emit()
	self.queue_free()


func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_detection_area = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player_in_detection_area = false


func _on_detection_area_mouse_entered() -> void:
	particle.show()


func _on_detection_area_mouse_exited() -> void:
	particle.hide()
