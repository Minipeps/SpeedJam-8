extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = 200
const FRICTION = 40

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta):
	self._handleMovement(delta)

func _handleMovement(delta):
	# Add gravity
	self.velocity.y += gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("player_move_up") and is_on_floor():
		self.velocity.y = -JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var horizontal_input = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	var direction = Vector2(horizontal_input, 0).normalized()
	self.velocity.x += direction.x * SPEED * delta
	
	# Apply user input and update floor_normal
	var collider = self.move_and_slide()
	
	# Accelerate/deccelerate on slopes
	var floor_normal = get_floor_normal()
	if abs(floor_normal.x) > 1e-3:
		print(floor_normal)
		self.velocity.x += floor_normal.x * SPEED * delta
	# On flat terrain, apply friction
	else:
		apply_friction(delta)
	
func apply_friction(delta):
	if (velocity.x > 0):
		self.velocity.x -= FRICTION * delta
	elif (velocity.x < 0):
		self.velocity.x += FRICTION * delta
