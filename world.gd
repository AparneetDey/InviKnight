class_name World
extends Node2D

@export var player : Player

@onready var stage : Node2D = $Stage

func _ready() -> void:
	if(player):
		player.global_position = stage.spawnPosition
