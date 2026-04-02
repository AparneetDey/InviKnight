class_name Stage
extends Node2D

@onready var playerSpawnPosition : Node2D = $PlayerSpawnPosition

var spawnPosition : Vector2 = Vector2.ZERO

func _ready() -> void:
	spawnPosition = playerSpawnPosition.global_position
