extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	# global_transform.origin.y = sin(global_transform.origin.x + time / 2.0) * sin(global_transform.origin.z + time / 2.0) * 5.0 / 2.0
	
	if Input.is_action_pressed("move_left"):
		global_rotation.y += delta;
		pass
	if Input.is_action_pressed("move_right"):
		global_rotation.y -= delta;
		pass
	if Input.is_action_pressed("move_up"):
		global_transform.origin += global_transform.basis.z * delta * 50.0
		pass
	if Input.is_action_pressed("move_down"):
		global_transform.origin -= global_transform.basis.z * delta * 10.0
		pass
