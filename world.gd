class_name World
extends Node2D

const STAGE_MAP := [
	preload("res://stages/level_1.tscn"),
	preload("res://stages/level_2.tscn"),
	preload("res://stages/level_3.tscn"),
]

@export var player : Player

var currentStageScene : Stage = null
var stageIndex : int = 0

func _ready() -> void:
	handleStageLoad()
	SignalManager.stageRetry.connect(onStageRetry.bind())
	SignalManager.stageNext.connect(onStageNext.bind())
	MusicPlayer.play()

func handleStageLoad() -> void:
	if(currentStageScene):
		currentStageScene.queue_free()
		currentStageScene = null
	
	currentStageScene = STAGE_MAP[stageIndex].instantiate()
	add_child(currentStageScene)
	player.global_position = currentStageScene.spawnPosition
	player.velocity = Vector2.ZERO
	player.state = player.State.IDLE
	player.isInvincible = false
	player.invincibleTimer.stop()

func onStageRetry() -> void:
	handleStageLoad()

func onStageNext() -> void:
	if(stageIndex < STAGE_MAP.size()-1):
		stageIndex += 1
	else:
		stageIndex = 0
	
	handleStageLoad()
