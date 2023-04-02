extends Node3D


var offset = Vector2.ZERO: set = _set_offset

func _set_offset(new_offset):
	RenderingServer.global_shader_parameter_set("water_offset", new_offset)
	offset = new_offset
	global_transform.origin = Vector3(offset.x, -3.0, offset.y)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	RenderingServer.global_shader_parameter_set("water_time", time)
