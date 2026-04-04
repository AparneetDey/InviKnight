class_name TimeLabel
extends Label

func _ready() -> void:
	SignalManager.updateLevelTime.connect(onUpdateLevelTime.bind())

func onUpdateLevelTime(time: float) -> void:
	var sec := int(time)
	var msec := fmod(time, 1.0) * 100
	
	text = "%02d:%02d" % [sec, msec]
