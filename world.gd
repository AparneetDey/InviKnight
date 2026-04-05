class_name World
extends Node2D

const STAGE_MAP := [
	preload("res://stages/level_1.tscn"),
	preload("res://stages/level_2.tscn"),
	preload("res://stages/level_3.tscn"),
]

@export var player : Player

var currentStageScene : Stage = null
var collectedBottles : int = 0
var stageIndex : int = 0
var timeLeft := 0.0
var timerActive := false
var totalBottlesInLevel : int = 0

func _ready() -> void:
	handleStageLoad()
	SignalManager.stageCompleted.connect(onStageCompleted.bind())
	SignalManager.stageOver.connect(onStageOver.bind())
	SignalManager.stageRetry.connect(onStageRetry.bind())
	SignalManager.stageNext.connect(onStageNext.bind())
	SignalManager.pickedInvincibility.connect(onBottleCollected.bind())

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
	collectedBottles = 0
	if(currentStageScene):
		currentStageScene.queue_free()
		currentStageScene = null
	
	currentStageScene = STAGE_MAP[stageIndex].instantiate()
	timeLeft = currentStageScene.levelTime
	add_child(currentStageScene)
	totalBottlesInLevel = currentStageScene.totalBottles
	timerActive = true
	player.global_position = currentStageScene.spawnPosition
	player.velocity = Vector2.ZERO
	player.state = Player.State.IDLE
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

func onStageCompleted() -> void:
	timerActive = false
	SignalManager.updateStars.emit(calculateStars())

func onStageOver() -> void:
	timerActive = false
	SignalManager.updateStars.emit(0)

func onBottleCollected(_time: float) -> void:
	collectedBottles += 1

func calculateStars() -> int:
	var per := (float(collectedBottles) / totalBottlesInLevel) * 100
	
	if(per >= 100): return 3
	elif(per >= 60): return 2
	return 1
