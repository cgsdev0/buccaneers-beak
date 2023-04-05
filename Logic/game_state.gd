extends Node


var map_pieces = [ false, false, false, false ]


func next_map() -> int:
	for i in range(map_pieces.size()):
		if !map_pieces[i]:
			return i
	return map_pieces.size()
	
func _ready():
	acquire_map.connect(_acquire_map)
	
func _acquire_map(i: int) -> void:
	map_pieces[i] = true

signal acquire_map(i: int)
