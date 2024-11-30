extends CharacterBody2D

@export var SPEED = 200.0
@export var JUMP_VELOCITY = 300
@export var FRICTION = 0.2
@export var MAX_FALL_HEIGHT = 32
@export var GRAVITY_FACTOR = 1
@export var TECH_TOLERANCE_TIME = 0.1
@export var TECH_ANIMATION_TOLERANCE_TIME = 0.3

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
@onready var techTimer: Timer = $TechTimer
@onready var techAnimationTimer: Timer = $TechAnimationTimer
var attemptingTech: bool = false

func _ready():
	techTimer.set_one_shot(true)
	techTimer.set_wait_time(TECH_TOLERANCE_TIME)
	techTimer.timeout.connect(_on_tech_timer_elapsed)
	
	techAnimationTimer.set_one_shot(true)
	techAnimationTimer.set_wait_time(TECH_ANIMATION_TOLERANCE_TIME)
	techAnimationTimer.timeout.connect(_reset_color)

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
			_change_state(State.DEAD)
			_die()
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("player_move_up"):
		_change_state(State.PREPARE_JUMP)
	elif Input.is_action_just_released("player_move_up"):
		self.velocity.y = -JUMP_VELOCITY
		_leave_floor()
		_change_state(State.JUMPING)
		move_and_slide()
		return
	# Accelerate/deccelerate on slopes
	var floor_normal = get_floor_normal()
	if abs(floor_normal.x) > 1e-3:
		self.velocity.x += (floor_normal.x*GRAVITY_FACTOR) * SPEED * delta
	# On flat terrain, apply friction
	else:
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
		_change_state(State.IDLE)

	# Apply velocity and update floor_normal
	move_and_slide()
	
func _apply_friction(delta):
	if (velocity.x > 0):
		self.velocity.x -= FRICTION * SPEED * delta
	elif (velocity.x < 0):
		self.velocity.x += FRICTION * SPEED * delta

func _leave_floor():
	heightWhenLeavingFloor = position.y
	leftTheFloor = true

func _check_death_by_fall() -> bool:
	# Player already on the floor
	if not leftTheFloor:
		return false
	# Check against latest height on floor
	leftTheFloor = false
	return (position.y - heightWhenLeavingFloor) > MAX_FALL_HEIGHT

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
	_apply_tech_color()
	pass

func _on_dead_state_entered():
	animatedSprite.play("death")
	
func _reset_color():
	$AnimatedSprite2D.modulate = Color(1., 1., 1.)

func _apply_tech_color():
	var normalized = techAnimationTimer.time_left / techAnimationTimer.wait_time
	$AnimatedSprite2D.modulate.v = normalized*15.

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
