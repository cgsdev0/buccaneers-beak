extends CharacterBody3D


@onready var player = get_tree().get_first_node_in_group("player")
@onready var player_parent = player.get_parent()

var out = true
@export var allowed = false

func allow_driving():
	allowed = true
	if !out:
		Story.enable_boat_interaction.emit()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	if !OS.is_debug_build():
		allowed = false
	floor_max_angle = 0

func get_perch():
	return $%Perch
	
func get_camera():
	return $CameraController
	
func get_water_height(world_position: Vector2):
	var water_time = Time.get_ticks_msec() / 1000.0
	var w1 = sin(world_position.x / 10.0 + water_time / 1.0) * sin(world_position.y / 10.0 + water_time / 5.0) * 2.0;
	var w2 = sin(world_position.x / 18.0 - water_time / 20.0) * sin(world_position.y / 10.0 - water_time / 20.0) * 2.0;
	return (w1 + w2) / 2.0 - 3.2;
	
func get_water_normal(pos: Vector2, forward: Vector3, right: Vector3):
	var time = Time.get_ticks_msec() / 1000.0
	var front = pos + Vector2(forward.x, forward.z)
	var back = pos - Vector2(forward.x, forward.z)
	var cross = Vector3(right.x, 0, right.y)
	return Vector3(front.x, get_water_height(front), front.y) - Vector3(back.x, get_water_height(back), back.y)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_just_pressed("enter_boat") && allowed:
		if !$CameraController.active && player.get_camera().active:
			if !out:
				player.disable_collider()
				$CameraController.active = true
				player_parent.remove_child(player)
				add_child(player)
				player.global_transform.origin = global_transform.origin + Vector3(0.0, 1.0, 0.0)
				Story.disable_boat_interaction.emit()
				Story.enable_boat_exit_interaction.emit()
		elif $CameraController.active:
			Story.disable_boat_exit_interaction.emit()
			remove_child(player)
			player_parent.add_child(player)
			player.global_transform.origin = global_transform.origin + Vector3(0.0, 1.0, 0.0)
			player.global_rotation.y = global_rotation.y - PI / 2
			player.enable_collider()
			player.activate_camera()
			Story.enable_boat_interaction.emit()
			out = false
		
	var input = Input.get_vector("move_right", "move_left", "move_down", "move_up")
	if !$CameraController.active:
		input = Vector2.ZERO
	
	global_rotation.y += input.x * delta
	
	var planar_origin = Vector2(global_transform.origin.x, global_transform.origin.z)
	$RootNode.look_at(global_transform.origin - get_water_normal(planar_origin, global_transform.basis.z, global_transform.basis.x),
		global_transform.basis.y)
	
	
	var vh = Vector2(velocity.x, velocity.z)
	if input.y < 0.0:
		input.y *= 0.7
	var ih = global_transform.basis.z * input.y * 0.5

	ih = Vector2(ih.x, ih.z)
	vh += ih
	
	# apply max speed
	vh = vh.limit_length(20.0)
	if input.y < 0.0:
		vh = vh.limit_length(10.0)
	
	# apply friction
	vh -= vh.normalized() * delta * 10.0 * min(vh.length(), 1)
	
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


func _on_area_3d_body_entered(body):
	if $CameraController.active:
		return
	out = false
	if allowed:
		Story.enable_boat_interaction.emit()

func _on_area_3d_body_exited(body):
	out = true
	Story.disable_boat_interaction.emit()
