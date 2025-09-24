extends Node

@export_category("Audio")
@export var sfx_player: AudioStreamPlayer
@export var music_player: AudioStreamPlayer


func _ready() -> void:
    Signals.play_sound.connect(play_audio)
    Signals.stop_play_sound.connect(stop_audio)

func play_audio(audio_type: State.AudioType, audio_stream: AudioStream, pitch_scale: float = 1.0, volume_db: float = 0) -> void:

    var player: AudioStreamPlayer = null

    match audio_type:
        State.AudioType.Effect: 
            player = sfx_player
            State.can_play_sfx = false
        State.AudioType.Music: player = music_player

    if player != null:
        player.stream = audio_stream
        player.pitch_scale = pitch_scale
        player.volume_db = volume_db
        player.play()
        await player.finished
        
        if audio_type == State.AudioType.Effect:
            State.can_play_sfx = true

func stop_audio(audio_type: State.AudioType) -> void:
    match audio_type:
        State.AudioType.Effect: 
            sfx_player.stop()
            State.can_play_sfx = true
        State.AudioType.Music: music_player.stop()