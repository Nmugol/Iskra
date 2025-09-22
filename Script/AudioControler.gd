extends Node

@export_category("Audio")
@export var sfx_player: AudioStreamPlayer
@export var music_player: AudioStreamPlayer


func _ready() -> void:
    Signals.play_sound.connect(play_audio)

func play_audio(audio_type: State.AudioType, audio_stream: AudioStream, pitch_scale: float = 1.0, volume_db: float = 0) -> void:

    var player: AudioStreamPlayer = null

    match audio_type:
        State.AudioType.Effect: 
            player = sfx_player
        State.AudioType.Music: player = music_player

    if player != null:
        player.stream = audio_stream
        player.pitch_scale = pitch_scale
        player.volume_db = volume_db
        player.play()