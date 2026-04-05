extends Control

const GAME_SCENE := preload("res://world.tscn")
const CONTROLS_SCENE := preload("res://ui/controls_ui.tscn")
const OBJECTIVE_SCENE := preload("res://ui/objective_ui.tscn")

@onready var startButton : Button = $Content/StartButton
@onready var controlsButton : Button = $Content/ControlsButton
@onready var objectiveButton : Button = $Content/ObjectiveButton
@onready var exitButton : Button = $Content/ExitButton

var controlsScene : MenuUI = null
var objectiveScene : MenuUI = null

func _ready() -> void:
	get_tree().paused = false
	MusicPlayer.play()
	SignalManager.closeMenu.connect(onCloseMenu)
	startButton.pressed.connect(onStartPressed.bind())
	controlsButton.pressed.connect(onControlsPressed.bind())
	objectiveButton.pressed.connect(onObjectivePressed.bind())
	exitButton.pressed.connect(onExitPressed.bind())

func onStartPressed() -> void:
	SoundPlayer.play(SoundManager.Sound.CLICK)
	get_tree().change_scene_to_packed(GAME_SCENE)

func onExitPressed() -> void:
	SoundPlayer.play(SoundManager.Sound.CLICK)
	get_tree().quit()

func onControlsPressed() -> void:
	SoundPlayer.play(SoundManager.Sound.CLICK)
	if(not controlsScene):
		controlsScene = CONTROLS_SCENE.instantiate()
		add_child(controlsScene)

func onObjectivePressed() -> void:
	SoundPlayer.play(SoundManager.Sound.CLICK)
	if(not objectiveScene):
		objectiveScene = OBJECTIVE_SCENE.instantiate()
		add_child(objectiveScene)

func onCloseMenu() -> void:
	if(controlsScene):
		controlsScene.queue_free()
	if(objectiveScene):
		objectiveScene.queue_free()
