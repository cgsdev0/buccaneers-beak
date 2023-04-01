extends RemoteTransform3D

@export
var active = false : set = _set_active

var lerpFrom = Transform3D()
var lerpTimer = 1.0

func _set_active(new_active):
	if !active && new_active:
		lerpFrom = get_viewport().get_camera_3d().global_transform
		lerpTimer = 0.0
	active = new_active
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_SPACE):
		active = true
		
	if lerpTimer < 1.0 && active:
		lerpTimer += delta
		get_viewport().get_camera_3d().global_transform.origin = lerp(lerpFrom.origin, global_transform.origin, ease(lerpTimer, 0.5))
		get_viewport().get_camera_3d().global_transform.basis = Basis(lerp(lerpFrom.basis.get_rotation_quaternion(), global_transform.basis.get_rotation_quaternion(), ease(lerpTimer, 0.5)))
	if lerpTimer >= 1.0 && active:
		remote_path = get_viewport().get_camera_3d().get_path()
