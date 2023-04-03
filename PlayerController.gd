extends CharacterBody3D


const SPEED = 15.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$RemoteTransform3D.active = true

var _mouse_position = Vector2(0.0, 0.0)
@export_range(0.0, 1.0) var sensitivity = 0.25
var _total_pitch = 0.0

func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
		
func _update_mouselook():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	_mouse_position *= sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	
	# Prevents looking up/down too far
	pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
	_total_pitch += pitch

	rotate_y(deg_to_rad(-yaw))
	rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))

func _process(delta):
	_update_mouselook()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var space_state = get_world_3d().direct_space_state
	
	var prev = global_transform.origin
	move_and_slide()
	var dest = global_transform.origin
	dest.y = -1
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, dest)
	var result = space_state.intersect_ray(query)
	var angle = 10
	if result:
		angle = result.normal.angle_to(Vector3.UP)
	if angle > 0.8:
		global_transform.origin = prev
