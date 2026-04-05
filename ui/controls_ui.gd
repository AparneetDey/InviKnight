class_name MenuUI
extends Control

@onready var backButton : Button = $MarginContainer/VBoxContainer/BackButton

func _ready() -> void:
	backButton.pressed.connect(onBackPressed.bind())

func onBackPressed() -> void:
	SignalManager.closeMenu.emit()
