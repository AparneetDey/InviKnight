class_name Stage
extends Node2D

@export var levelTime : float

@onready var checkpoint : Checkpoint = $Checkpoint
@onready var playerSpawnPosition : Node2D = $PlayerSpawnPosition

var spawnPosition : Vector2 = Vector2.ZERO

func _ready() -> void:
	spawnPosition = playerSpawnPosition.global_position
	checkpoint.monitoring = false

func _process(_delta: float) -> void:
	await get_tree().create_timer(0.5).timeout
	checkpoint.monitoring = true
