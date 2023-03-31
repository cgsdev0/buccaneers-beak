extends CSGMesh3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var time = Time.get_ticks_msec() / 1000.0
	var mat = self.mesh.surface_get_material(0) as ShaderMaterial
	mat.set_shader_parameter("time", time)
	pass
