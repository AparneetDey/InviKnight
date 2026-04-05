extends Node

signal hitBreakbleWall(position: Vector2)
signal pickedInvincibility(time: float)

signal stageCompleted
signal stageRetry
signal stageNext
signal stageOver
signal stagePaused

signal spawnEffect(spawnPosition: Vector2)

signal updateLevelTime(time: float)

signal updateStars(stars: int)
signal showTimeLeft(time: float)

signal closeMenu
