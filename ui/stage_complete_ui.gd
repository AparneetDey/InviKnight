class_name StageStatusUI
extends Control

const MAIN_SCREEN := "res://main_menu.tscn"

const NO_STAR := preload("res://assets/sprites/no_star-sprite.png")
const FULL_STAR := preload("res://assets/sprites/full_star-sprite.png")

@onready var retryButton : Button = $Content/RetryButton
@onready var nextButton : Button = $Content/NextButton
@onready var homeButton : Button = $Content/HomeButton
@onready var continueButton : Button = $Content/ContinueButton
@onready var timeLabel : Label = $Content/TimeLabel
@onready var stars : Array[TextureRect] = [$Content/HBoxContainer/Star1, $Content/HBoxContainer/Star2, $Content/HBoxContainer/Star3]

func _ready() -> void:
	retryButton.pressed.connect(onRetryButtonPressed.bind())
	nextButton.pressed.connect(onNextButtonPressed.bind())
	homeButton.pressed.connect(onHomeButtonPressed.bind())
	continueButton.pressed.connect(onContinueButtonPressed.bind())
	SignalManager.updateStars.connect(onUpdateStars.bind())
	SignalManager.showTimeLeft.connect(onShowTimeLeft.bind())

func onRetryButtonPressed() -> void:
	SignalManager.stageRetry.emit()
	SoundPlayer.play(SoundManager.Sound.CLICK)

func onNextButtonPressed() -> void:
	SignalManager.stageNext.emit()
	SoundPlayer.play(SoundManager.Sound.CLICK)

func onHomeButtonPressed() -> void:
	SoundPlayer.play(SoundManager.Sound.CLICK)
	get_tree().change_scene_to_file(MAIN_SCREEN)

func onContinueButtonPressed() -> void:
	SignalManager.stagePaused.emit()
	SoundPlayer.play(SoundManager.Sound.CLICK)

func onUpdateStars(starCount: int) -> void:
	for i in range(3):
		if(i<starCount):
			stars[i].texture = FULL_STAR
		else:
			stars[i].texture = NO_STAR

func onShowTimeLeft(time: float) -> void:
	var sec := int(time)
	var msec := fmod(time, 1.0) * 100
	
	timeLabel.text = "%02d:%02d" % [sec, msec]
