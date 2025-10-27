extends Node2D

class_name Particles

@export var particle_to_play: Array[GPUParticles2D]


func _play_particle() -> void:
	for p in particle_to_play:
		p.emitting = true
