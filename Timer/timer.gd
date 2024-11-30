extends Control

var UPDATE_TIMER : bool

func _ready():
	start_timer()

func _process(delta):
	update_timer(delta)
	update_timer_label(Globals.TIME_ELAPSED)

func start_timer():
	UPDATE_TIMER = true
	
func update_timer(delta):
	if UPDATE_TIMER:
		Globals.TIME_ELAPSED += delta
	
func stop_and_reset_timer():
	Globals.TIME_ELAPSED = 0.0
	UPDATE_TIMER = false
	
func restart_timer():
	stop_and_reset_timer()
	start_timer()

func update_timer_label(time_elapsed):
	$Label.text = Globals.get_formulated_time_elapsed()
