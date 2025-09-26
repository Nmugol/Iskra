class_name Track
extends Node2D

@export var speed: float = 60.0  # Zmieniono na bardziej realistyczną prędkość
@export var attach: Area2D
var cart: Cart
@export var attach_to: PathFollow2D
@export var flip_x: bool
@export var flip_y: bool

var path_length: float
var attach_flag: bool = false

func _ready() -> void:
	update_scale()
	
	if attach:
		attach.body_entered.connect(_on_attach_body_entered)
	
	# Dodano walidację struktury ścieżki
	if attach_to:
		var path = attach_to.get_parent() as Path2D
		if path:
			if path.curve != null:
				path_length = path.curve.get_baked_length()
				# Wymuś aktualizację PathFollow2D
				attach_to.progress = 0.0
				attach_to.loop = false

func _process(delta: float) -> void:
	if attach_flag and attach_to and path_length > 0:
		# Aktualizacja z zabezpieczeniem przekroczenia długości
		attach_to.progress = min(attach_to.progress + speed * delta, path_length)
		
		if attach_to.progress >= path_length:
			handle_end_of_path()

func update_scale() -> void:
	# Ustaw skalę jednorazowo zamiast w każdej klatce
	scale.x = -1 if flip_x else 1
	scale.y = -1 if flip_y else 1

func _on_attach_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Cart"):
		return
	
	if not is_instance_valid(cart) or not is_instance_valid(attach_to):
		return
	
	attach.queue_free()
	# Bezpieczne przenoszenie rodzica
	reparent_cart()

func reparent_cart() -> void:
	if not is_instance_valid(cart) or not is_instance_valid(attach_to):
		return
	
	# Bezpieczne usuwanie rodzica
	if cart.get_parent():
		cart.get_parent().remove_child(cart)
	
	# Opóźnione dodawanie do nowego rodzica
	call_deferred("_deferred_reparent")

func _deferred_reparent() -> void:
	if not attach_to.is_inside_tree():
		return
	
	# Usunięto ręczne ustawianie pozycji - PathFollow2D sam kontroluje pozycję
	attach_to.add_child(cart)
	
	# Resetowanie transformacji lokalnej
	cart.position = Vector2.ZERO
	cart.rotation = 0.0
	
	attach_to.progress = 0.0
	attach_flag = true
	Signals.cart_game_timer_off.emit()

func handle_end_of_path() -> void:
	# Tutaj dodaj logikę przejścia do następnego segmentu
	attach_flag = false
	Signals.cart_game_timer_on.emit()