extends CharacterBody3D


const SPEED = 12.0
const JUMP_VELOCITY = 15.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var inside = false

func disable_collider():
	self.set_collision_layer_value(1, false)

func enable_collider():
	self.set_collision_layer_value(1, false)
	$RemoteTransform3D.rotation = Vector3.ZERO
	
func activate_camera():
	$RemoteTransform3D.active = true
	
func _ready():
	floor_snap_length = 1.0
	floor_max_angle = 0.9 # 0.785398

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	activate_camera()

var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

func get_water_height(world_position: Vector2):
	var water_time = Time.get_ticks_msec() / 1000.0
	var wave1 = sin((world_position.x) / 40.0 + water_time / 3.0) * sin((world_position.y) / 37.0 + water_time / 3.0) * 3.0;
	var wave2 = sin((world_position.x) / 40.0 - water_time / 3.0) * 3.0;
	return (wave1 + wave2) / 2.0 - 3.0;
	
func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
		
func _update_mouselook():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	_mouse_position *= GameState.sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	
	# Prevents looking up/down too far
	pitch = clamp(pitch, -90 - _total_pitch, 90 - _total_pitch)
	_total_pitch += pitch

	rotate_y(deg_to_rad(-yaw))
	$RemoteTransform3D.rotate_object_local(Vector3(1,0,0), deg_to_rad(-pitch))

func _process(delta):
	_update_mouselook()
	
func _physics_process(delta):
	if !$RemoteTransform3D.active:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	var speed_modifier = 1.0
	var wh = get_water_height(Vector2(global_transform.origin.x, global_transform.origin.z)) - 1.7
	if wh >= global_transform.origin.y && !inside:
		global_transform.origin.y = wh
		velocity.y = max(0.0, velocity.y)
	
	if global_transform.origin.y <= 0.0 && !is_on_floor():
		speed_modifier = 0.4
		
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED * speed_modifier
		velocity.z = direction.z * SPEED * speed_modifier
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	var space_state = get_world_3d().direct_space_state
	
	var prev = global_transform.origin
	move_and_slide()
#	var dest = global_transform.origin
#	dest.y = -1
#	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, dest)
#	var result = space_state.intersect_ray(query)
#	var angle = 10
#	if result:
#		angle = result.normal.angle_to(Vector3.UP)
#	if angle > 0.8:
#		global_transform.origin = prev
