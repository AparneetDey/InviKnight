class_name InvinsibleBottle
extends Area2D

@export var invincibilityTime : float

func _ready() -> void:
	body_entered.connect(onPlayerEntered.bind())
	$CollisionShape2D.disabled = true

func _process(_delta: float) -> void:
	await get_tree().create_timer(0.1).timeout
	$CollisionShape2D.disabled = false

func onPlayerEntered(body: Node2D) -> void:
	if(body is Player):
		SignalManager.pickedInvincibility.emit(invincibilityTime)
		SoundPlayer.play(SoundManager.Sound.PICK_UP)
		queue_free()
