@tool
extends GPUParticles2D

@export var playing_time: float = 0.3
@export var play: bool = false:
	set(value):
		play = value
		if value:
			emitting = true
			await get_tree().create_timer(playing_time).timeout
			emitting = false
			play = false
