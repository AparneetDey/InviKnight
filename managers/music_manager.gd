class_name MusicManager
extends Node

const MUSIC_PREFAB := preload("res://assets/music/time_for_adventure.mp3")

@onready var musicStreamPlayer : AudioStreamPlayer = $MusicStreamPlayer

var audioStream : AudioStream = null

func _process(_delta: float) -> void:
	if(audioStream):
		musicStreamPlayer.stream = audioStream
		musicStreamPlayer.stream.loop = true
		musicStreamPlayer.play()

func play() -> void:
	if(musicStreamPlayer.is_node_ready()):
		musicStreamPlayer.stream = MUSIC_PREFAB
		musicStreamPlayer.stream.loop = true
		musicStreamPlayer.play()
	else:
		audioStream = MUSIC_PREFAB
