extends Camera2D

@export var CAMERA_SHAKE_STRENGTH = 10
@export var CAMERA_SPEED_EFFECT = 100

var targetPos: Vector2

var shake: bool = false

func _process(delta):
	position = position.move_toward(targetPos, 0.8)
	if shake:
		position += get_shake_amount()

func reset_shake():
	shake = false

func camera_shake():
	shake = true

func get_shake_amount() -> Vector2:
	var shakeAmount: Vector2
	shakeAmount.x = randi_range(1,CAMERA_SHAKE_STRENGTH) - CAMERA_SHAKE_STRENGTH/2
	shakeAmount.y = randi_range(1,CAMERA_SHAKE_STRENGTH) - CAMERA_SHAKE_STRENGTH/2
	return shakeAmount

func apply_velocity(speed: float, max_speed: float):
	targetPos = lerp(Vector2.ZERO, Vector2(CAMERA_SPEED_EFFECT, 0), speed / max_speed)
