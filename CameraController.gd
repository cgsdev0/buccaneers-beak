class_name CameraController extends RemoteTransform3D

@export var active = false : set = _set_active

var lerpFrom = Transform3D()
var lerpTimer = 1.0
var prev = null

func previous_camera():
	if prev:
		prev.active = true
	
func _set_active(new_active):
	if !active && new_active:
		lerpFrom = get_viewport().get_camera_3d().global_transform
		lerpTimer = 0.0
		if is_instance_of(get_viewport().get_camera_3d().controller, CameraController):
			get_viewport().get_camera_3d().controller.active = false
			prev = get_viewport().get_camera_3d().controller
		get_viewport().get_camera_3d().controller = self
	if !new_active && active:
		remote_path = NodePath("")
	active = new_active
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("camera_controllers")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		
	if lerpTimer < 1.0 && active:
		lerpTimer += delta
		get_viewport().get_camera_3d().global_transform.origin = lerp(lerpFrom.origin, global_transform.origin, ease(lerpTimer, 0.5))
		get_viewport().get_camera_3d().global_transform.basis = Basis(lerpFrom.basis.get_rotation_quaternion().slerp(global_transform.basis.get_rotation_quaternion(), ease(lerpTimer, 0.5)))
	if lerpTimer >= 1.0 && active:
		remote_path = get_viewport().get_camera_3d().get_path()
