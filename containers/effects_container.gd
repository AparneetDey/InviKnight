class_name EffectsContainer
extends Node2D

const EFFECT_PREFAB := preload("res://vfx/explosion.tscn")

func _init() -> void:
	SignalManager.spawnEffect.connect(onSpawnEffect.bind())

func onSpawnEffect(spawnPosition: Vector2) -> void:
	var effect := EFFECT_PREFAB.instantiate()
	effect.global_position = spawnPosition
	add_child(effect)
