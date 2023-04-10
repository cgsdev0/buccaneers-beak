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

func get_camera():
	return $RemoteTransform3D
	
func get_water_height(world_position: Vector2):
	var water_time = Time.get_ticks_msec() / 1000.0
	var w1 = sin(world_position.x / 10.0 + water_time / 1.0) * sin(world_position.y / 10.0 + water_time / 5.0) * 2.0;
	var w2 = sin(world_position.x / 18.0 - water_time / 20.0) * sin(world_position.y / 10.0 - water_time / 20.0) * 2.0;
	return (w1 + w2) / 2.0 - 3.0;
	
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
	_total_pitch += pitch
	_total_pitch = clamp(_total_pitch, -90.0, 90.0)

	rotate_y(deg_to_rad(-yaw))
	$RemoteTransform3D.rotation = Vector3.ZERO
	$RemoteTransform3D.rotate_object_local(Vector3(1,0,0), deg_to_rad(-_total_pitch))

func _process(delta):
	_update_mouselook()
	
func _physics_process(delta):
	if !$RemoteTransform3D.active:
		return
		
	var fly_hack = OS.is_debug_build() && Input.is_key_pressed(KEY_SHIFT)
	
	# Add the gravity.
	if not is_on_floor()  && !fly_hack:
		velocity.y -= gravity * delta

	var speed_modifier = 1.0
	var wh = get_water_height(Vector2(global_transform.origin.x, global_transform.origin.z)) - 1.7
	if wh >= global_transform.origin.y && !inside:
		global_transform.origin.y = wh
		velocity.y = max(0.0, velocity.y)
	
	if global_transform.origin.y <= 0.0 && !is_on_floor():
		speed_modifier = 0.5
	
	if fly_hack:
		speed_modifier = 10.0
		
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
	if is_on_floor() && $RemoteTransform3D.active:
		if $GroundCast.is_colliding() && Vector2(velocity.x, velocity.z).length() > 3.0:
			if $GroundCast.get_collider().get_collision_mask_value(3):
				if !$Sounds/StepWood.playing:
					$Sounds/StepWood.play_random()
			else:
				if !$Sounds/StepGravel.playing:
					$Sounds/StepGravel.play_random()
#	var dest = global_transform.origin
#	dest.y = -1
#	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, dest)
#	var result = space_state.intersect_ray(query)
#	var angle = 10
#	if result:
#		angle = result.normal.angle_to(Vector3.UP)
#	if angle > 0.8:
#		global_transform.origin = prev
