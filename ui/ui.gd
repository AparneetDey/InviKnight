class_name UI
extends CanvasLayer

const STAGE_COMPLETE_PREFAB := preload("res://ui/stage_complete_ui.tscn")
const STAGE_OVER_PREFAB := preload("res://ui/stage_over_ui.tscn")
const STAGE_PAUSED_PREFAB := preload("res://ui/stage_paused_ui.tscn")

var stageCompleteScene : StageStatusUI = null
var stageOverScene : StageStatusUI = null
var stagePausedScene : StageStatusUI = null

func _init() -> void:
	SignalManager.stageCompleted.connect(onStageComplete.bind())
	SignalManager.stageOver.connect(onStageOver.bind())
	SignalManager.stageRetry.connect(onStageStart)
	SignalManager.stageNext.connect(onStageStart)
	SignalManager.stagePaused.connect(onStagePause)

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("pause") and not stageCompleteScene and not stageOverScene):
		onStagePause()

func onStageComplete() -> void:
	if(stageCompleteScene == null):
		stageCompleteScene = STAGE_COMPLETE_PREFAB.instantiate()
		SoundPlayer.play(SoundManager.Sound.LEVEL_COMPLETE)
		add_child(stageCompleteScene)

func onStageOver() -> void:
	if(stageOverScene == null):
		stageOverScene = STAGE_OVER_PREFAB.instantiate()
		SoundPlayer.play(SoundManager.Sound.LEVEL_OVER)
		add_child(stageOverScene)

func onStagePause() -> void:
	if(stagePausedScene):
		stagePausedScene.queue_free()
		get_tree().paused = false
	else:
		stagePausedScene = STAGE_PAUSED_PREFAB.instantiate()
		add_child(stagePausedScene)
		get_tree().paused = true

func onStageStart() -> void:
	if(stageCompleteScene):
		stageCompleteScene.queue_free()
	if(stageOverScene):
		stageOverScene.queue_free()
	if(stagePausedScene):
		stagePausedScene.queue_free()
		get_tree().paused = false
