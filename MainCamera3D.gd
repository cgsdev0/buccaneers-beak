extends Camera3D

var controller = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_parent().get_node("Water").offset = Vector2(global_transform.origin.x, global_transform.origin.z)
	pass
