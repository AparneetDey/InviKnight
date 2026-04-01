class_name  Player
extends CharacterBody2D

const GRAVITY = 500

@export var acceleration : int
@export var dashSpeed : int
@export var durationJustDashed : float
@export var friction : int
@export var jumpIntensity : int
@export var maxSpeed : int

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var characterSprite : Sprite2D = $CharacterSprite
@onready var dashTimer : Timer = $DashTimer


enum State {IDLE, WALK, JUMP, DASH}
const animMap : Dictionary = {
	State.IDLE: "idle",
	State.WALK: "walk",
	State.JUMP: "jump",
	State.DASH: "dash",
}

var dir : float = 0.0
var dashDir : Vector2 = Vector2.RIGHT
var speed : int = 0
var state = State.IDLE
var timeSinceDashed : float = Time.get_ticks_msec()

func _ready() -> void:
	speed = maxSpeed
	dashTimer.timeout.connect(onDashTimeout.bind())

func _physics_process(delta: float) -> void:
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
	elif(velocity.x < 0):
		characterSprite.flip_h = true

func applyGravity(delta: float) -> void:
	if(not is_on_floor()):
		velocity.y += GRAVITY * delta

func applyAcceleration(delta: float) -> void:
	velocity.x = move_toward(velocity.x , speed*dir, acceleration*delta)

func applyFriction(delta: float) -> void:
	velocity.x = move_toward(velocity.x , 0, friction*delta)

func handleInput() -> void:
	if(Input.is_action_just_pressed("jump") and is_on_floor()):
		state = State.JUMP
		velocity.y = -jumpIntensity
	
	if(Input.is_action_just_pressed("dash") and state != State.DASH):
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
	return state==State.IDLE or state == State.WALK

func onActionComplete() -> void:
	state = State.IDLE

func onDashTimeout() -> void:
	if(state == State.DASH):
		state = State.IDLE
		timeSinceDashed = Time.get_ticks_msec()
