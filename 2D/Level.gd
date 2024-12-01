extends Node2D

var LAST_CHECKPOINT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_timer()
	position_player_at_start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_speedCounter()
	pass
	
func _input(event):
	if Input.is_action_just_pressed("load_checkpoint"):
		load_last_checkpoint()

func register_checkpoint(checkpoint_reference):
	if LAST_CHECKPOINT != checkpoint_reference:
		LAST_CHECKPOINT = checkpoint_reference
		print("Debug : " + checkpoint_reference.name)

func load_last_checkpoint():
	if LAST_CHECKPOINT != null:
		$Player2d.position = LAST_CHECKPOINT.global_position
		$Player2d.reset_player()
		LAST_CHECKPOINT = null
	else:
		restart_level()
	
func update_speedCounter():
	if $CanvasLayer/SpeedCounter:
		$CanvasLayer/SpeedCounter.SPEED_TO_DISPLAY = $Player2d.velocity.x
		
func position_player_at_start():
	if $PlayerStart and $Player2d:
		$Player2d.position = $PlayerStart.position

func restart_timer():
	if $CanvasLayer/Timer:
		$CanvasLayer/Timer.restart_timer()
		
func restart_level():
	restart_timer()
	position_player_at_start()
	$Player2d.reset_player()
	LAST_CHECKPOINT = null
