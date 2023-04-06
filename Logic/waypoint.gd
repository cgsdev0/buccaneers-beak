class_name Waypoint extends Marker3D

@export var map_id: int = 0 
@export var sequence_id: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("waypoints")
