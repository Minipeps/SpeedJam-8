extends AudioStreamPlayer

var currentPos = 0.0
# Called when the node enters the scene tree for the first time.
func pause():
	currentPos = get_playback_position()
	stop()

func resume():
	play(currentPos)
