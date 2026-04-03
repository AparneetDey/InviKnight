class_name UI
extends CanvasLayer

const STAGE_COMPLETE_PREFAB := preload("res://ui/stage_complete_ui.tscn")

var stageCompleteScene : Control = null

func _init() -> void:
	SignalManager.stageCompleted.connect(onStageComplete.bind())
	SignalManager.stageRetry.connect(onStageStart)
	SignalManager.stageNext.connect(onStageStart)

func onStageComplete() -> void:
	if(stageCompleteScene == null):
		stageCompleteScene = STAGE_COMPLETE_PREFAB.instantiate()
		add_child(stageCompleteScene)

func onStageStart() -> void:
	if(stageCompleteScene):
		stageCompleteScene.queue_free()
