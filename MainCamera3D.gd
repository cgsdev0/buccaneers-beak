extends Camera3D

var controller = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var boat = get_tree().get_first_node_in_group("boat")
	get_parent().get_node("Water").offset = Vector2(global_transform.origin.x, global_transform.origin.z)
	if boat && !boat.get_camera().active:
		return
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(global_transform.origin, boat.global_transform.origin + Vector3(0.0, 0.5, 0.0), 4)
	var result = space_state.intersect_ray(query)
	if "position" in result:
		RenderingServer.global_shader_parameter_set("hole_punch", result.position)
	else:
		RenderingServer.global_shader_parameter_set("hole_punch", Vector3.ZERO)
