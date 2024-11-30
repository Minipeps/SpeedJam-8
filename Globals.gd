extends Node

var TIME_ELAPSED : float

func get_formulated_time_elapsed() -> String:
	var minutes : int = TIME_ELAPSED / 60.0
	var seconds : int = fmod(TIME_ELAPSED, 60.0)
	var microseconds : int = (TIME_ELAPSED - int(TIME_ELAPSED)) * 100
	return "%02d:%02d:%02d" % [minutes, seconds, microseconds]
