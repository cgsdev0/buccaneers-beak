extends AudioStreamPlayer

var initial_db = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	initial_db = volume_db
