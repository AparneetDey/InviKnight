class_name Checkpoint
extends Area2D

@export var isLastLevel : bool = false

func _init() -> void:
	body_entered.connect(onPlayerEntered.bind())

func onPlayerEntered(body: Node2D) -> void:
	if(body is Player):
		if(isLastLevel):
			SignalManager.gameCompleted.emit()
		else:
			SignalManager.stageCompleted.emit()
