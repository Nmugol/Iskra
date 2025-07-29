@tool
extends GPUParticles2D

@export var time_to_disable: float = 0.3
@export var play: bool = false:
	set(value):
		play = value
		if value:
			emitting = true
			await get_tree().create_timer(time_to_disable).timeout
			emitting = false
			play = false
