extends Control

@export var SPEED_LIMIT : float = 20.
var SPEED_TO_DISPLAY : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var speed = snapped(absf(SPEED_TO_DISPLAY)/SPEED_LIMIT, 0.1)
	#$Label.text = "%02fkm/h" % [speed]
	$Label.text = str(speed) + " km/h"
	$Label.modulate = Color(speed/10., 0., 0.)
	pass
