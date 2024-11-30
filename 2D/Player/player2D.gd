extends CharacterBody2D

const SPEED = 1000.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handleMovement(delta):
	# Handle jump.
		# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		self.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var horizontal_input = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	var moveVector = Vector2(horizontal_input, 0).normalized()
	var direction = moveVector.normalized()
	if direction:
		self.velocity.x = direction.x * SPEED * delta
	else:
		self.velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	print(velocity)
	var collider = self.move_and_slide()

func _physics_process(delta):
	self._handleMovement(delta)
