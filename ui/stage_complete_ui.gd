class_name StageStatusUI
extends Control

const MAIN_SCREEN := "res://main_menu.tscn"

const NO_STAR := preload("res://assets/sprites/no_star-sprite.png")
const FULL_STAR := preload("res://assets/sprites/full_star-sprite.png")

@onready var retryButton : Button = $Content/RetryButton
@onready var nextButton : Button = $Content/NextButton
@onready var homeButton : Button = $Content/HomeButton
@onready var stars : Array[TextureRect] = [$Content/HBoxContainer/Star1, $Content/HBoxContainer/Star2, $Content/HBoxContainer/Star3]

func _ready() -> void:
	retryButton.pressed.connect(onRetryButtonPressed.bind())
	nextButton.pressed.connect(onNextButtonPressed.bind())
	homeButton.pressed.connect(onHomeButtonPressed.bind())
	SignalManager.updateStars.connect(onUpdateStars.bind())

func onRetryButtonPressed() -> void:
	SignalManager.stageRetry.emit()

func onNextButtonPressed() -> void:
	SignalManager.stageNext.emit()

func onHomeButtonPressed() -> void:
	get_tree().change_scene_to_file(MAIN_SCREEN)

func onUpdateStars(starCount: int) -> void:
	for i in range(3):
		if(i<starCount):
			stars[i].texture = FULL_STAR
		else:
			stars[i].texture = NO_STAR
