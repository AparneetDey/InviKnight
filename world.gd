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
var timeLeft := 0.0
var timerActive := false

func _ready() -> void:
	handleStageLoad()
	SignalManager.stageCompleted.connect(onTimerPause)
	SignalManager.stageOver.connect(onTimerPause)
	SignalManager.stageRetry.connect(onStageRetry.bind())
	SignalManager.stageNext.connect(onStageNext.bind())
	MusicPlayer.play()

func _process(delta: float) -> void:
	if(timerActive):
		if(timeLeft > 0):
			SignalManager.updateLevelTime.emit(timeLeft)
			timeLeft -= delta
		else:
			SignalManager.updateLevelTime.emit(0.0)
			SignalManager.stageOver.emit()

func handleStageLoad() -> void:
	timerActive = false
	if(currentStageScene):
		currentStageScene.queue_free()
		currentStageScene = null
	
	currentStageScene = STAGE_MAP[stageIndex].instantiate()
	timeLeft = currentStageScene.levelTime
	add_child(currentStageScene)
	timerActive = true
	player.global_position = currentStageScene.spawnPosition
	player.velocity = Vector2.ZERO
	player.state = player.State.IDLE
	player.isInvincible = false
	player.invincibleTimer.stop()
	player.hasStoredPower = true

func onStageRetry() -> void:
	handleStageLoad()

func onStageNext() -> void:
	if(stageIndex < STAGE_MAP.size()-1):
		stageIndex += 1
	else:
		stageIndex = 0
	
	handleStageLoad()

func onTimerPause() -> void:
	timerActive = false
