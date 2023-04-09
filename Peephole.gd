extends TextureRect


@export_range(0.0, 1.0) var peephole = 0.0
@export var peephole_base_size: float = 30

var mat: ShaderMaterial

func _ready():
	mat = get_material()

func screen_scale():
	return min(get_window().size.x / 1920.0, get_window().size.y / 1080.0)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var peephole_size = screen_scale() * peephole_base_size
	mat.set_shader_parameter("anchor_position", $Control/Anchor.global_position)
	mat.set_shader_parameter("peephole", peephole)
	mat.set_shader_parameter("size", peephole_size)
