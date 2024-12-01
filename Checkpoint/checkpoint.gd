extends Node2D

func _ready():
	$AnimatedSprite2D.play("redflag")

func _on_area_2d_body_entered(body):
	$AnimatedSprite2D.play("greenflag")
	get_owner().register_checkpoint(self)
