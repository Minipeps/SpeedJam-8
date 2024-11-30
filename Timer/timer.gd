extends Control

var TIME_ELAPSED : float = 0.0
var UPDATE_TIMER : bool

func _ready():
	start_timer()

func _process(delta):
	update_timer(delta)
	update_timer_label(TIME_ELAPSED)

func start_timer():
	UPDATE_TIMER = true
	
func update_timer(delta):
	if UPDATE_TIMER:
		TIME_ELAPSED += delta
	
func stop_and_reset_timer():
	TIME_ELAPSED = 0.0
	UPDATE_TIMER = false
	
func restart_timer():
	stop_and_reset_timer()
	start_timer()

func update_timer_label(time_elapsed):
	var minutes : int = time_elapsed / 60.0
	var seconds : int = fmod(time_elapsed, 60.0)
	var microseconds : int = (time_elapsed - int(time_elapsed)) * 100
	$Label.text = "%02d:%02d:%02d" % [minutes, seconds, microseconds]
