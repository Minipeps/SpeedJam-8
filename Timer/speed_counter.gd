extends Control

var SPEED_TO_DISPLAY : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = "%02fkm/h" % [absf(SPEED_TO_DISPLAY)/20]
	pass
