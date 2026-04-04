class_name Stage
extends Node2D

@export var levelTime : float

@onready var checkpoint : Checkpoint = $Checkpoint
@onready var collectibleContainer : Node2D = $CollectibleContainer
@onready var playerSpawnPosition : Node2D = $PlayerSpawnPosition

var spawnPosition : Vector2 = Vector2.ZERO
var totalBottles : int = 0

func _ready() -> void:
	totalBottles = collectibleContainer.get_child_count()
	spawnPosition = playerSpawnPosition.global_position
	checkpoint.monitoring = false

func _process(_delta: float) -> void:
	await get_tree().create_timer(0.5).timeout
	checkpoint.monitoring = true
