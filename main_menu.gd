extends Control

const GAME_SCENE := preload("res://world.tscn")

@onready var startButton : Button = $Content/StartButton

func _ready() -> void:
	MusicPlayer.play()
	startButton.pressed.connect(onStartPresses.bind())

func onStartPresses() -> void:
	get_tree().change_scene_to_packed(GAME_SCENE)
