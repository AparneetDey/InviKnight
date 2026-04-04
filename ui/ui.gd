class_name UI
extends CanvasLayer

const STAGE_COMPLETE_PREFAB := preload("res://ui/stage_complete_ui.tscn")
const STAGE_OVER_PREFAB := preload("res://ui/stage_over_ui.tscn")

var stageCompleteScene : StageStatusUI = null
var stageOverScene : StageStatusUI = null

func _init() -> void:
	SignalManager.stageCompleted.connect(onStageComplete.bind())
	SignalManager.stageOver.connect(onStageOver.bind())
	SignalManager.stageRetry.connect(onStageStart)
	SignalManager.stageNext.connect(onStageStart)

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

func onStageStart() -> void:
	if(stageCompleteScene):
		stageCompleteScene.queue_free()
	if(stageOverScene):
		stageOverScene.queue_free()
