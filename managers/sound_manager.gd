class_name SoundManager
extends Node

@onready var sounds : Array[AudioStreamPlayer] = [$SFXPickUp, $SFXExplosion, $SFXHurt, $SFXJump, $SFXPowerUp, $SFXPowerDown, $SFXLevelComplete]

enum Sound {PICK_UP, EXPLOSION, HURT, JUMP, POWER_UP, POWER_DOWN, LEVEL_COMPLETE}

func play(sfx: Sound, tweakPitch : bool = false):
	var addedPitch := 0.0
	if tweakPitch:
		addedPitch += randf_range(-0.3, 0.3)
	sounds[sfx as int].pitch_scale = 1 + addedPitch
	sounds[sfx as int].play()
