class_name StageCompleteUI
extends Control

@onready var retryButton : Button = $RetryButton
@onready var nextButton : Button = $NextButton

func _ready() -> void:
	retryButton.pressed.connect(onRetryButtonPressed.bind())
	nextButton.pressed.connect(onNextButtonPressed.bind())

func onRetryButtonPressed() -> void:
	SignalManager.stageRetry.emit()

func onNextButtonPressed() -> void:
	SignalManager.stageNext.emit()
