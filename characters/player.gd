class_name  Player
extends CharacterBody2D

const GRAVITY = 500

@export var acceleration : int
@export var dashSpeed : int
@export var friction : int
@export var jumpIntensity : int
@export var maxSpeed : int

@onready var dashTimer : Timer = $DashTimer

enum State {IDLE, WALK, JUMP, DASH}

var dir : float = 0.0
var dashDir : Vector2 = Vector2.RIGHT
var speed : int = 0
var state = State.IDLE

func _ready() -> void:
	speed = maxSpeed
	dashTimer.timeout.connect(onDashTimeout.bind())

func _physics_process(delta: float) -> void:
	applyGravity(delta)
	handleMovement(delta)
	move_and_slide()

func applyGravity(delta: float) -> void:
	if(not is_on_floor()):
		velocity.y += GRAVITY * delta

func applyAcceleration(delta: float) -> void:
	velocity.x = move_toward(velocity.x , speed*dir, acceleration*delta)

func applyFriction(delta: float) -> void:
	velocity.x = move_toward(velocity.x , 0, friction*delta)

func handleMovement(delta: float) -> void:
	dir = Input.get_axis("ui_left", "ui_right")
	if(dir==0):
		state = State.IDLE
		applyFriction(delta)
	else:
		state = State.WALK
		applyAcceleration(delta)
		dashDir = Vector2.RIGHT if dir > 0 else Vector2.LEFT
	
	if(Input.is_action_just_pressed("jump") and is_on_floor()):
		state = State.JUMP
		velocity.y = -jumpIntensity
	
	if(Input.is_action_just_pressed("dash") and state != State.DASH):
		state = State.DASH
		velocity = dashDir * dashSpeed
		dashTimer.start()

func onDashTimeout() -> void:
	if(state == State.DASH):
		state = State.IDLE
