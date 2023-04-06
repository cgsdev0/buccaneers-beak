extends Node

enum Pickup {
	PIPE,
	APPLE
}

var item_names = {
	Pickup.PIPE: "Mysterious Pipe",
	Pickup.APPLE: "Apple",
}

var map_pieces = [ false, false, false, false ]

var inventory = {
	
}

func is_map_complete():
	return next_map() == map_pieces.size()
	
func next_map() -> int:
	for i in range(map_pieces.size()):
		if !map_pieces[i]:
			return i
	return map_pieces.size()
	
func _ready():
	call_deferred("cheats")

func cheats():
	acquire_map(1)
	acquire_map(2)
	acquire_map(3)
	
func pickup(item: Pickup):
	if inventory.has(item):
		inventory[item] += 1
	else:
		inventory[item] = 1
	on_pickup.emit(item)

func has_item(item: Pickup, count = 1) -> bool:
	return inventory.has(item) && inventory[item] >= count
		
func delete_item(item: Pickup):
	inventory.erase(item)
	on_delete_item.emit(item)
	
func acquire_map(i: int) -> void:
	map_pieces[i] = true
	on_acquire_map.emit(i)

signal on_acquire_map(i: int)
signal on_pickup(item: Pickup)
signal on_delete_item(item: Pickup)
