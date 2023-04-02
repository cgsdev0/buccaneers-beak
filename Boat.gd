extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	floor_max_angle = 0
	pass # Replace with function body.

func get_water_height(pos: Vector2):
	var time = Time.get_ticks_msec() / 1000.0
	return sin(pos.x / 40.0 + time / 2.0) * sin(pos.y / 40.0 + time / 2.0) * 5.0 - 3.0
	
func get_water_normal(pos: Vector2, forward: Vector3, right: Vector3):
	var time = Time.get_ticks_msec() / 1000.0
	var front = pos + Vector2(forward.x, forward.z)
	var back = pos - Vector2(forward.x, forward.z)
	var cross = Vector3(right.x, 0, right.y)
	return Vector3(front.x, get_water_height(front), front.y) - Vector3(back.x, get_water_height(back), back.y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		$CameraController.active = true
	var input = Input.get_vector("move_right", "move_left", "move_down", "move_up")
	
	global_rotation.y += input.x * delta
	
	var planar_origin = Vector2(global_transform.origin.x, global_transform.origin.z)
	$RootNode.look_at(global_transform.origin - get_water_normal(planar_origin, global_transform.basis.z, global_transform.basis.x),
		global_transform.basis.y)
	
	
	var vh = Vector2(velocity.x, velocity.z)
	var ih = global_transform.basis.z * input.y
	ih = Vector2(ih.x, ih.z)
	vh += ih
	
	# apply max speed
	vh = vh.limit_length(30.0)
	
	# apply friction
	vh -= vh.normalized() * delta * 50.0 * min(vh.length(), 1)
	
	var water_height = get_water_height(planar_origin)
	
	# global_transform.origin.y = water_height
	
	if velocity.y < 1.0 && abs(water_height - global_transform.origin.y) < 0.05:
		velocity.y = 0
		global_transform.origin.y = water_height
	else:
		# apply gravity
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") * delta
		
		# apply buoyancy
		if global_transform.origin.y < water_height:
			velocity.y += delta * 2 * min(2, (water_height - global_transform.origin.y) * 5.0) * ProjectSettings.get_setting("physics/3d/default_gravity")
		
	velocity.y = min(50.0, velocity.y)
	
	velocity = Vector3(vh.x, velocity.y, vh.y)
	
	move_and_slide()
	if global_transform.origin.y < water_height - 0.5:
		global_transform.origin.y = water_height - 0.5
