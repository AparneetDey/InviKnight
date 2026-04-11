class_name  Player
extends CharacterBody2D

const GRAVITY := 500
const GRAVITY_MULTIPLIER := 3
const POWER_UP_BONUS := 50

@export var acceleration : int
@export var maxDashSpeed : int
@export var durationJustDashed : float
@export var friction : int
@export var jumpIntensity : int
@export var maxSpeed : int
@export var timeAddOnKill : float

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var characterSprite : Sprite2D = $CharacterSprite
@onready var collisionShape : CollisionShape2D = $CollisionShape2D
@onready var dashTimer : Timer = $DashTimer
@onready var emitterPivot : Node2D = $EmitterPivot
@onready var enemyDamageEmitter : Area2D = $EnemyDamageEmitter
@onready var invincibleTimer : Timer = $InvincibleTimer
@onready var wallDamageEmitter : Area2D = $EmitterPivot/DamageEmitter


enum State {IDLE, WALK, JUMP, DASH, POWER_UP, POWER_DOWN, FROZEN, FALL, DEATH}
const animMap : Dictionary = {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.JUMP: "jump",
	State.DASH: "dash",
	State.POWER_UP: "powerUp",
	State.POWER_DOWN: "powerDown",
	State.FROZEN: "idle",
	State.FALL: "fall",
	State.DEATH: "death",
}

var dir : float = 0.0
var dashDir : Vector2 = Vector2.RIGHT
var isInvincible : bool = false
var currentGravity : int = 0
var dashSpeed : int = 0
var speed : int = 0
var jumpForce : int = 0
var state = State.IDLE
var timeSinceDashed : float = Time.get_ticks_msec()

func _init() -> void:
	SignalManager.pickedInvincibility.connect(onPickedInvincibility.bind())
	SignalManager.stageCompleted.connect(onPlayerFrozen.bind())
	SignalManager.gameCompleted.connect(onPlayerFrozen.bind())
	SignalManager.stageOver.connect(onPlayerFrozen.bind())

func _ready() -> void:
	speed = maxSpeed
	dashSpeed = maxDashSpeed
	jumpForce = jumpIntensity
	currentGravity = GRAVITY
	dashTimer.timeout.connect(onDashTimeout.bind())
	wallDamageEmitter.body_entered.connect(onBreakWall.bind())
	enemyDamageEmitter.area_entered.connect(onDamageEmit.bind())
	invincibleTimer.timeout.connect(onInvincibilityTimeOut.bind())

func _physics_process(delta: float) -> void:
	wallDamageEmitter.monitoring = state == State.DASH
	handleAnimation()
	flipSprites()
	applyGravity(delta)
	handleInput()
	handleMovement(delta)
	move_and_slide()

func handleAnimation() -> void:
	if(animationPlayer.has_animation(animMap[state])):
		animationPlayer.play(animMap[state])

func flipSprites() -> void:
	if(velocity.x > 0):
		characterSprite.flip_h = false
		emitterPivot.scale.x = 1
	elif(velocity.x < 0):
		characterSprite.flip_h = true
		emitterPivot.scale.x = -1

func applyGravity(delta: float) -> void:
	currentGravity = GRAVITY
	
	if(velocity.y > 0):
		currentGravity *= GRAVITY_MULTIPLIER
		
	if(not is_on_floor()):
		velocity.y += currentGravity * delta
	else:
		velocity.y = 0

func applyAcceleration(delta: float) -> void:
	velocity.x = move_toward(velocity.x , speed*dir, acceleration*delta)

func applyFriction(delta: float) -> void:
	velocity.x = move_toward(velocity.x , 0, friction*delta)

func handleInput() -> void:
	if(Input.is_action_just_pressed("ui_up") and is_on_floor() and canJump()):
		state = State.JUMP
		velocity.y = -jumpForce
		SoundPlayer.play(SoundManager.Sound.JUMP)
	
	if(Input.is_action_just_pressed("dash") and state != State.DASH and canDash()):
		if((Time.get_ticks_msec() - timeSinceDashed) > durationJustDashed):
			state = State.DASH
			velocity = dashDir * dashSpeed
			dashTimer.start()

func handleMovement(delta: float) -> void:
	if(not canMove()):
		return
	
	dir = Input.get_axis("ui_left", "ui_right")
	if(dir==0):
		state = State.IDLE
		applyFriction(delta)
	else:
		state = State.WALK
		applyAcceleration(delta)
		dashDir = Vector2.RIGHT if dir > 0 else Vector2.LEFT

func canMove() -> bool:
	return state==State.IDLE or state == State.WALK or state == State.JUMP

func canJump() -> bool:
	return state == State.IDLE or state == State.WALK

func canDash() -> bool:
	return state == State.IDLE or state == State.WALK or state == State.JUMP

func onActionComplete() -> void:
	state = State.IDLE
	if(isInvincible):
		invincibleTimer.start()

func onDeathComplete() -> void:
	if(state==State.FALL):
		state = State.DEATH
		SignalManager.stageOver.emit()

func onDashTimeout() -> void:
	if(state == State.DASH):
		state = State.IDLE
		timeSinceDashed = Time.get_ticks_msec()

func onBreakWall(body: Node2D) -> void:
	if(body is TileMapLayer):
		if(isInvincible):
			SignalManager.hitBreakbleWall.emit(wallDamageEmitter.global_position)
			dashTimer.stop()
		state = State.IDLE
		velocity = Vector2.ZERO

func onDamageEmit(receiver: DamageReceiver) -> void:
	if(isInvincible):
		receiver.damageReceived.emit()
		var newTime := invincibleTimer.time_left + timeAddOnKill
		invincibleTimer.wait_time = newTime
		invincibleTimer.start()
	else:
		state = State.FALL
		velocity = Vector2.ZERO
		SoundPlayer.play(SoundManager.Sound.HURT)

func onPickedInvincibility(invincibilityTime: float) -> void:
	speed = maxSpeed
	jumpForce = jumpIntensity
	dashSpeed = maxDashSpeed
	if(isInvincible):
		var newTime := invincibleTimer.time_left + invincibilityTime
		invincibleTimer.wait_time = newTime
		invincibleTimer.start()
	else:
		isInvincible = true
		invincibleTimer.wait_time = invincibilityTime
	
	speed += POWER_UP_BONUS
	jumpForce += POWER_UP_BONUS
	dashSpeed += POWER_UP_BONUS
	state = State.POWER_UP
	velocity = Vector2.ZERO
	SoundPlayer.play(SoundManager.Sound.POWER_UP)

func onInvincibilityTimeOut() -> void:
	isInvincible = false
	state = State.POWER_DOWN
	velocity = Vector2.ZERO
	speed = maxSpeed
	jumpForce = jumpIntensity
	SoundPlayer.play(SoundManager.Sound.POWER_DOWN)

func onPlayerFrozen() -> void:
	if(state != State.DEATH):
		state = State.FROZEN
		velocity = Vector2.ZERO
		speed = maxSpeed
		jumpForce = jumpIntensity
