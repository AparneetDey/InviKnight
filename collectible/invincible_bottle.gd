class_name InvinsibleBottle
extends Area2D

func _ready() -> void:
	body_entered.connect(onPlayerEntered.bind())

func onPlayerEntered(body: Node2D) -> void:
	if(body is Player):
		SignalManager.pickedInvincibility.emit()
		queue_free()
