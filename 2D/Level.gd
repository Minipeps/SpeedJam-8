extends Node2D

var LAST_CHECKPOINT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _input(event):
	if Input.is_action_just_pressed("load_checkpoint"):
		load_last_checkpoint()

func register_checkpoint(checkpoint_reference):
	LAST_CHECKPOINT = checkpoint_reference
	print(checkpoint_reference.name)

func load_last_checkpoint():
	if LAST_CHECKPOINT != null:
		$Player2d.position = LAST_CHECKPOINT.position
		$Player2d.reset_player()
