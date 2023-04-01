extends CharacterBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	floor_max_angle = 0
	pass # Replace with function body.

func get_water_height(pos: Vector2):
	var time = Time.get_ticks_msec() / 1000.0
	return sin(pos.x / 40.0 + time / 2.0) * sin(pos.y / 40.0 + time / 2.0) * 5.0 - 2.9
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var input = Input.get_vector("move_right", "move_left", "move_down", "move_up")
	
	global_rotation.y += input.x * delta
	
	var vh = Vector2(velocity.x, velocity.z)
	var ih = global_transform.basis.z * input.y
	ih = Vector2(ih.x, ih.z)
	vh += ih
	
	# apply max speed
	vh = vh.limit_length(30.0)
	
	# apply friction
	vh -= vh.normalized() * delta * 50.0 * min(vh.length(), 1)
	
	var water_height = get_water_height(Vector2(global_transform.origin.x, global_transform.origin.z))
	
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
