extends Node2D

func _on_area_2d_body_entered(body):
	body._apply_tech_fail_effect()
