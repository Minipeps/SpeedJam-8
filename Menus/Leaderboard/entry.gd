extends Control

func set_username(user: String):
	$Username.text = user

func set_time(time: float):
	var minutes : int = time / 60.0
	var seconds : int = fmod(time, 60.0)
	var microseconds : int = (time - int(time)) * 100
	$Time.text = "%02d:%02d:%02d" % [minutes, seconds, microseconds]
