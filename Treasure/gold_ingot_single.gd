extends RigidBody3D


var rng = RandomNumberGenerator.new()
var round2 = false

func rand():
	return rng.randf_range(-50.0, 50.0)
# Called when the node enters the scene tree for the first time.
func _ready():
	apply_torque_impulse(Vector3(rand(),rand(),rand()))
	apply_impulse(Vector3(rand(),rand(),rand()))
	

var timer = 0.0
func _process(delta):
	if timer > 10.0 && !round2:
		round2 = true
		apply_torque_impulse(Vector3(rand(),rand(),rand()))
		apply_impulse(Vector3(rand(),rand(),rand()))
	if timer > 30.0:
		freeze = true
