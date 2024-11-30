extends Node2D

@export var CHECKPOINT_NUMBER : int = 0

func _on_area_2d_body_entered(body):
	print("checkpoint crossed" + body.name)
	pass
