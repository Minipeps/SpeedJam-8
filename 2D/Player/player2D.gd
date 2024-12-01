extends CharacterBody2D

@export var SPEED = 200.0
@export var MAX_JUMP_VELOCITY = 300
@export var TIME_TO_REACH_MAX_JUMP_VELOCITY = 1.
@export var MAX_JUMP_DURATION = 3.
@export var FRICTION = 0.2
@export var MAX_FALL_HEIGHT = 32
@export var GRAVITY_FACTOR = 1
@export var FALL_FACTOR = 4
@export var TECH_TOLERANCE_TIME = 0.1
@export var FLASH_TIME = 0.2
@export var SPARkLE_TIME = 0.2
@export var CAMERA_SHAKE_STRENGTH= 10

signal on_player_death

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animatedSprite : AnimatedSprite2D = $AnimatedSprite2D;

enum State {
	IDLE,
	PREPARE_JUMP,
	JUMPING,
	KICKING,
	ROLLING,
	FALLING,
	TECH,
	DEAD
}

var currentState: State
var leftTheFloor: bool = false
var heightWhenLeavingFloor: float
var isDead: bool = false
@onready var loadingJumpTimer: Timer = $LoadingJumpTimer
@onready var techTimer: Timer = $TechTimer
@onready var techAnimationTimer: Timer = $TechAnimationTimer
@onready var fallAnimationTimer: Timer = $FallAnimationTimer
@onready var flyingTimer: Timer = $FlyingTimer
@onready var sparkleTimer: Timer = $SparkleTimer
var attemptingTech: bool = false

func _ready():
	techTimer.set_one_shot(true)
	techTimer.set_wait_time(TECH_TOLERANCE_TIME)
	techTimer.timeout.connect(_on_tech_timer_elapsed)
	
	techAnimationTimer.set_one_shot(true)
	techAnimationTimer.set_wait_time(FLASH_TIME)
	techAnimationTimer.timeout.connect(_reset_color)
	
	fallAnimationTimer.set_one_shot(true)
	fallAnimationTimer.set_wait_time(FLASH_TIME)
	fallAnimationTimer.timeout.connect(_reset_color)
	fallAnimationTimer.timeout.connect(_reset_camera)
	
	loadingJumpTimer.set_one_shot(true)
	loadingJumpTimer.set_wait_time(TIME_TO_REACH_MAX_JUMP_VELOCITY)
	
	flyingTimer.set_one_shot(true)
	flyingTimer.set_wait_time(MAX_JUMP_DURATION)
	
	sparkleTimer.set_one_shot(true)
	sparkleTimer.set_wait_time(SPARkLE_TIME)
	sparkleTimer.timeout.connect(_stop_sparkling)

func reset_player():
	isDead = false
	leftTheFloor = false
	velocity = Vector2.ZERO

func _check_for_tech_attempt():
	if Input.is_action_just_pressed("player_move_down"):
		techTimer.start()
		attemptingTech = true

func _on_tech_timer_elapsed():
	attemptingTech = false

func _physics_process(delta):
	if velocity.x < 50:
		_start_sparkling()
	else:
		_stop_sparkling()
	if fallAnimationTimer.is_stopped() == false:
		_apply_fall_color()
		_camera_shake();
	if techAnimationTimer.is_stopped() == false:
		_apply_tech_color()
	if not isDead:
		_handleMovement(delta)

func _handleMovement(delta):
	# Add gravity
	self.velocity.y += gravity * delta

	# Check for tech
	_check_for_tech_attempt()

	# Do not update player velocity if we are not on the floor
	if not is_on_floor():
		if not leftTheFloor:
			_leave_floor()
		if self.velocity.y >= 0:
			_change_state(State.FALLING)
		move_and_slide()
		return

	# Check for death by fall
	if _check_death_by_fall():
		if attemptingTech:
			_change_state(State.TECH)
			print("Tech successful!")
		else:
			_apply_tech_fail_effect()
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("player_move_up"):
		_change_state(State.PREPARE_JUMP)
	elif Input.is_action_just_released("player_move_up"):
		var jump_factor = 1
		if not loadingJumpTimer.is_stopped():
			jump_factor = (loadingJumpTimer.wait_time - loadingJumpTimer.time_left)/loadingJumpTimer.wait_time
		self.velocity.y = -(jump_factor*MAX_JUMP_VELOCITY)
		loadingJumpTimer.stop()
		_leave_floor()
		_change_state(State.JUMPING)
		move_and_slide()
		return
	# Accelerate/deccelerate on slopes
	var floor_normal = get_floor_normal()
	if abs(floor_normal.x) > 1e-3:
		self.velocity.x += (floor_normal.x*GRAVITY_FACTOR) * SPEED * delta
		#set_rotation(PI/2 - acos(floor_normal.x/2))
	# On flat terrain, apply friction
	else:
		#set_rotation(0)
		_apply_friction(delta)

	# Get the input direction and handle the movement
	var horizontal_input = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	var direction = Vector2(horizontal_input, 0).normalized()
	if direction.x != 0:
		self.velocity.x += direction.x * SPEED * delta
		_change_state_conditional(State.KICKING, currentState != State.PREPARE_JUMP)
	elif abs(velocity.x) > 1:
		_change_state_conditional(State.ROLLING, currentState != State.PREPARE_JUMP)
	else:
		_change_state_conditional(State.IDLE, currentState != State.PREPARE_JUMP)

	# Apply velocity and update floor_normal
	move_and_slide()
	
func _apply_friction(delta):
	if (velocity.x > 0):
		self.velocity.x -= FRICTION * SPEED * delta
	elif (velocity.x < 0):
		self.velocity.x += FRICTION * SPEED * delta
		
func _apply_tech_fail_effect():
	fallAnimationTimer.start()
	velocity.x /= FALL_FACTOR

func _leave_floor():
	heightWhenLeavingFloor = position.y
	leftTheFloor = true
	flyingTimer.start()

func _check_death_by_fall() -> bool:
	# Player already on the floor
	if not leftTheFloor:
		return false
	# Check against latest height on floor
	leftTheFloor = false
	return flyingTimer.is_stopped()

func _die():
	isDead = true
	on_player_death.emit()

func _change_state(newState: State):
	if newState == currentState:
		return
	
	currentState = newState
	print("newState: ", _state_to_string(newState))
	
	if newState == State.IDLE:
		_on_idle_state_entered()
	elif newState == State.PREPARE_JUMP:
		loadingJumpTimer.start()
		_on_prepare_jump_state_entered()
	elif newState == State.JUMPING:
		_on_jumping_state_entered()
	elif newState == State.KICKING:
		_on_kicking_state_entered()
	elif newState == State.ROLLING:
		_on_rolling_state_entered()
	elif newState == State.FALLING:
		_on_falling_state_entered()
	elif newState == State.TECH:
		_on_tech_state_entered()
	elif newState == State.DEAD:
		_on_dead_state_entered()

func _change_state_conditional(newState: State, condition: bool):
	if condition:
		_change_state(newState)

func _on_idle_state_entered():
	animatedSprite.play("default")

func _on_prepare_jump_state_entered():
	animatedSprite.play("preparejump")

func _on_jumping_state_entered():
	animatedSprite.play("jumping")
	
func _on_falling_state_entered():
	animatedSprite.play("falling")
	
func _on_kicking_state_entered():
	animatedSprite.play("kick")
	
func _on_rolling_state_entered():
	animatedSprite.play("rolling")

func _on_tech_state_entered():
	techAnimationTimer.start()
	pass

func _on_dead_state_entered():
	animatedSprite.play("death")
	
func _reset_color():
	$AnimatedSprite2D.modulate = Color(1., 1., 1.)

func _reset_camera():
	$Camera2D.position = Vector2.ZERO

func _apply_tech_color():
	var normalized = techAnimationTimer.time_left / techAnimationTimer.wait_time
	$AnimatedSprite2D.modulate.v = normalized*15.
	
func _camera_shake():
	_reset_camera()
	$Camera2D.position.x += randi_range(1,CAMERA_SHAKE_STRENGTH) - CAMERA_SHAKE_STRENGTH/2
	$Camera2D.position.y += randi_range(1,CAMERA_SHAKE_STRENGTH) - CAMERA_SHAKE_STRENGTH/2
	
func _apply_fall_color():
	var normalized = fallAnimationTimer.time_left / fallAnimationTimer.wait_time
	$AnimatedSprite2D.modulate = Color(1., normalized, 1.)
	
func _start_sparkling():
	$Sparkle.amount = 30

func _stop_sparkling():
	$Sparkle.amount = 0

func _state_to_string(state: State) -> String:
	if state == State.IDLE:
		return "IDLE"
	if state == State.PREPARE_JUMP:
		return "PREPARE_JUMP"
	if state == State.JUMPING:
		return "JUMPING"
	if state == State.KICKING:
		return "KICKING"
	if state == State.ROLLING:
		return "ROLLING"
	if state == State.FALLING:
		return "FALLING"
	if state == State.TECH:
		return "TECH"
	if state == State.DEAD:
		return "DEAD"
	return "UNKNOWN"
