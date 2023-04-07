extends Node3D

var out = true

var boat = null
var attached = true

#var current_basis
#var target_basis
# Called when the node enters the scene tree for the first time.
func _ready():
	$parrot/AnimationPlayer.play("breathe")
	if owner:
		boat = owner
	GameState.on_acquire_map.connect(got_new_map)
#	current_basis = global_transform.basis

func got_new_map(i: int) -> void:
	$Arrow.visible = true
	if !out:
		Story.enable_interaction.emit(Story.Character.PARROT)
		
var velocity = Vector3.ZERO
var rotation_speed = 0.0
var speed = 0.0
var target = Vector3.ZERO
var actual_target = Vector3.ZERO
var waypoint_list = []
var boost = false
var landing = false
func _process(delta):
	if attached:
		return
	if (boat_to_target() < 15.0 || landing):
		if waypoint_list.is_empty():
			target = boat.get_perch().global_transform.origin
			land()
			boost = false
		else:
			actual_target = waypoint_list[0]
			target = actual_target
			waypoint_list.pop_front()
	elif dist_to_boat() > 80.0:
		target = boat.global_transform.origin
		boost = true
	elif dist_to_boat() < 50.0:
		target = actual_target
		boost = false
	global_transform.origin += velocity * delta
	var boostv = boat.velocity.length() / 3.0
	if boost:
		boostv = boat.velocity.length()
	velocity = velocity.move_toward(global_transform.basis.z * speed, delta * speed * 3.0).limit_length(speed + boostv)
	
#	if target_basis:
#		global_transform.basis = Basis(current_basis.get_rotation_quaternion().slerp(
#			target_basis.get_rotation_quaternion(), basis_lerp)).scaled(
#				lerp(current_basis.get_scale(), target_basis.get_scale(), basis_lerp))
#		if basis_lerp >= 1.0:
#			target_basis = null

	var turn_mod = 2.0
	if landing:
		turn_mod = 10.0
	var q = from_to_rotation(global_transform.origin, target)
	var ang = min(PI, abs(global_transform.basis.get_rotation_quaternion().angle_to(q)))
	global_transform.basis = Basis(global_transform.basis.get_rotation_quaternion().slerp(
			q, clamp(delta * rotation_speed * (turn_mod / ang), 0.0, 1.0))).scaled(global_transform.basis.get_scale())
			
func boat_to_target():
	return (Vector2(boat.global_transform.origin.x, boat.global_transform.origin.z) - 
	Vector2(actual_target.x, actual_target.z)).length()
	
func dist_to_boat():
	return (Vector2(boat.global_transform.origin.x, boat.global_transform.origin.z) - 
	Vector2(global_transform.origin.x, global_transform.origin.z)).length()
	
func land():
	if landing:
		return
	landing = true
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "global_transform:origin:y", target.y + 3.0, 2.9).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rotation_speed", 0.0, 1.0).set_delay(3.0)
	tween.tween_property(self, "speed", 0.0, 2.0).set_delay(2.0)
	
	tween.tween_callback(toggle_trails.bind(false)).set_delay(3.0)
	await get_tree().create_timer(3.0).timeout
	var t = global_transform
	get_parent().remove_child(self)
	boat.get_perch().add_child(self)
	global_transform = t
	attached = true
	tween = get_tree().create_tween()
	tween.tween_property(self, "transform", Transform3D(), 1.0)
	$parrot/AnimationPlayer.play("land")
	await get_tree().create_timer(1.0).timeout
	landing = false
	
func from_to_rotation(from, to):
	from = Vector2(from.x, from.z)
	to = Vector2(to.x, to.z)
	var angle = from.angle_to_point(to)
	return Quaternion(Vector3.UP, -angle + PI /2)
	
func toggle_trails(val):
	$parrot/Wing1/Node3D/Trail3D.trailEnabled = val
	$parrot/Wing2/Node3D/Trail3D.trailEnabled = val
	
func update_waypoints():
	var waypoints = []
	var next_map = GameState.next_map()
	for waypoint in get_tree().get_nodes_in_group("waypoints"):
		if waypoint.map_id == next_map:
			waypoints.push_back(waypoint)
	waypoints.sort_custom(func(a, b): return a.sequence_id < b.sequence_id)
	self.waypoint_list = []
	for waypoint in waypoints:
		self.waypoint_list.push_back(waypoint.global_transform.origin)
	if self.waypoint_list.size() == 0:
		return false
	target = self.waypoint_list.pop_front()
	actual_target = target
	return true
		
func take_off():
	if !update_waypoints():
		return
		
	$parrot/AnimationPlayer.play("take_off")
	
	if boat && attached:
		boat.allow_driving()
		velocity = owner.velocity
		var t = global_transform
		get_parent().remove_child(self)
		boat.get_parent().add_child(self)
		global_transform = t
#		current_basis = global_transform.basis
		attached = false
		
	rotation_speed = 0.0
#	target_basis = from_to_rotation(global_transform.origin, Vector3.ZERO, scale)
#	print(current_basis, target_basis, basis_lerp)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(self, "global_transform:origin:y", 20.0, 4.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "rotation_speed", 1.0, 1.0).set_delay(1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "speed", 15.0, 5.0).set_delay(1.0)
	tween.tween_callback(toggle_trails.bind(true)).set_delay(2.0)

var explained_maps = [false, false, false, false, false]
var explained_twice = [false, false, false, false, false]
	
func _input(event):
	if out || !attached || Story.in_dialogue:
		return
	if event.is_action_pressed("interact"):
		match GameState.next_map():
			0:
				$CameraController.active = true
				Story.trigger(Story.Character.PARROT, "get_map_0")
				await Story.finish_dialogue
				$CameraController.previous_camera()
			1:
				$CameraController.active = true
				if !explained_maps[1]:
					Story.trigger(Story.Character.PARROT, "explain_map_1")
					$Arrow.visible = false
					await Story.finish_dialogue
					explained_maps[1] = true
					take_off()
					await get_tree().create_timer(1.0).timeout
				else:
					Story.trigger(Story.Character.PARROT, "get_map_1")
					await Story.finish_dialogue
					explained_twice[1] = true
				$CameraController.previous_camera()
			2:
				$CameraController.active = true
				if !explained_maps[2]:
					Story.trigger(Story.Character.PARROT, "explain_map_2")
					$Arrow.visible = false
					await Story.finish_dialogue
					explained_maps[2] = true
					take_off()
					await get_tree().create_timer(1.0).timeout
				else:
					Story.trigger(Story.Character.PARROT, "get_map_2")
					await Story.finish_dialogue
					explained_twice[2] = true
				$CameraController.previous_camera()
			4:
				$CameraController.active = true
				if !explained_maps[4]:
					Story.trigger(Story.Character.PARROT, "explain_map_4")
					$Arrow.visible = false
					await Story.finish_dialogue
					explained_maps[4] = true
					take_off()
					await get_tree().create_timer(1.0).timeout
				else:
					Story.trigger(Story.Character.PARROT, "get_map_4")
					await Story.finish_dialogue
					explained_twice[4] = true
				$CameraController.previous_camera()
		

func _on_area_3d_body_entered(body):
	out = false
	if !attached || explained_twice[GameState.next_map()]:
		return
	Story.enable_interaction.emit(Story.Character.PARROT)


func _on_area_3d_body_exited(body):
	out = true
	if !attached:
		return
	Story.disable_interaction.emit()
