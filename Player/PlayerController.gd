extends CharacterBody3D

@onready var headPivot: Node3D = $HeadPivot
@onready var controller: Node3D = $".."
const SPEED = 1000.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if (event is InputEventMouseMotion):
		self.rotate_y(event.relative.x * -0.001)
		headPivot.rotate_object_local(Vector3(1,0,0), event.relative.y * -0.001)
	
func _handleMovement(delta): 
	# Add the gravity.
	if not is_on_floor():
		self.velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		self.velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var vertical_input = Input.get_action_strength("player_move_up") - Input.get_action_strength("player_move_down")
	var horizontal_input = Input.get_action_strength("player_move_right") - Input.get_action_strength("player_move_left")
	var moveVector = Vector3(horizontal_input, 0, -vertical_input).normalized()
	var direction = (self.transform.basis * moveVector).normalized()
	if direction:
		self.velocity.x = direction.x * SPEED * delta
		self.velocity.z = direction.z * SPEED * delta
	else:
		self.velocity.x = move_toward(velocity.x, 0, SPEED * delta)
		self.velocity.z = move_toward(velocity.z, 0, SPEED * delta)
	print(velocity)
	var collider = self.move_and_slide()

func _physics_process(delta):
	self._handleMovement(delta)
	
	#if (collider):
	#print(velocity)
