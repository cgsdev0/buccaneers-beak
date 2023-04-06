extends MarginContainer


@export var tick = false
var timer = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_acquire_map.connect(on_map)

func on_map(i: int) -> void:
	get_child(i).material = null

func _process(delta):
	if tick:
		timer += delta
		var mat = $Shiny.material as ShaderMaterial
		mat.set_shader_parameter("time", timer)
