class_name UI
extends CanvasLayer

const STAGE_COMPLETE_PREFAB := preload("res://ui/stage_complete_ui.tscn")

var stageCompleteScene : Control = null

func _init() -> void:
	SignalManager.stageCompleted.connect(onStageComplete.bind())

func onStageComplete() -> void:
	if(stageCompleteScene == null):
		stageCompleteScene = STAGE_COMPLETE_PREFAB.instantiate()
		add_child(stageCompleteScene)
		get_tree().paused = true
