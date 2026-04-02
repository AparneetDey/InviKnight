class_name Checkpoint
extends Area2D

func _init() -> void:
	body_entered.connect(onPlayerEntered.bind())

func onPlayerEntered(body: Node2D) -> void:
	if(body is Player):
		SignalManager.stageCompleted.emit()
