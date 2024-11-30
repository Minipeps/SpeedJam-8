extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = 200
const FRICTION = 0.2

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum State {
	IDLE,
	JUMPING,
	KICKING,
	ROLLING,
	DEAD
}
var currentState: State

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	_handleMovement(delta)
	_handleAnimation()

func _handleMovement(delta):
	currentState = State.IDLE
	
	# Add gravity
	self.velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("player_move_up") and is_on_floor():
		self.velocity.y = -JUMP_VELOCITY
		currentState = State.JUMPING
		self.move_and_slide()
		return

	# Accelerate/deccelerate on slopes
	var floor_normal = get_floor_normal()
	if abs(floor_normal.x) > 1e-3:
		self.velocity.x += floor_normal.x * SPEED * delta
	# On flat terrain, apply friction
	else:
		_apply_friction(delta)

	# Get the input direction and handle the movement
	var horizontal_input = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	var direction = Vector2(horizontal_input, 0).normalized()
	if direction.x != 0:
		self.velocity.x += direction.x * SPEED * delta
		currentState = State.KICKING
	elif abs(velocity.x) > 0:
		currentState = State.ROLLING

	# Apply velocity and update floor_normal
	self.move_and_slide()
	
func _handleAnimation():
	pass
	
func _apply_friction(delta):
	if (velocity.x > 0):
		self.velocity.x -= FRICTION * SPEED * delta
	elif (velocity.x < 0):
		self.velocity.x += FRICTION * SPEED * delta
