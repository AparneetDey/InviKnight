class_name Enemy
extends CharacterBody2D

@onready var animationPLayer : AnimationPlayer = $AnimationPlayer
@onready var damageReceiver : DamageReceiver = $DamageReceiver

enum State {IDLE, DEATH}

var state := State.IDLE

func _ready() -> void:
	damageReceiver.damageReceived.connect(onDamageReceived.bind())

func _process(_delta: float) -> void:
	handleAnimation()

func handleAnimation() -> void:
	if(state == State.IDLE):
		animationPLayer.play("idle")
	elif(state==State.DEATH):
		animationPLayer.play("death")

func onDamageReceived() -> void:
	state = State.DEATH
	$CollisionShape2D.set_deferred("disabled", true)
