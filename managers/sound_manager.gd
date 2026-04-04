class_name SoundManager
extends Node

@onready var sounds : Array[AudioStreamPlayer] = [$SFXPickUp, $SFXExplosion, $SFXHurt, $SFXJump, $SFXPowerUp, $SFXPowerDown]

enum Sound {PICK_UP, EXPLOSION, HURT, JUMP, POWER_UP, POWER_DOWN}

func play(sfx: Sound, tweakPitch : bool = false):
	var addedPitch := 0.0
	if tweakPitch:
		addedPitch += randf_range(-0.3, 0.3)
	sounds[sfx as int].pitch_scale = 1 + addedPitch
	sounds[sfx as int].play()
