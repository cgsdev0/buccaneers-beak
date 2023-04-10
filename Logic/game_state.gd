extends Node

enum Pickup {
	PIPE,
	APPLE,
	SHELL
}

var item_names = {
	Pickup.PIPE: "Mysterious Pipe",
	Pickup.APPLE: "Apple",
	Pickup.SHELL: "Seashell"
}

var map_pieces = [ false, false, false, false ]

var inventory = {
	
}

var has_won = false

var scuffed_camera_detector = null;

var sensitivity = 0.25

func is_map_complete():
	return next_map() == map_pieces.size()
	
func next_map() -> int:
	for i in range(map_pieces.size()):
		if !map_pieces[i]:
			return i
	return map_pieces.size()
	
func on_win():
	has_won = true
	
func _ready():
	Story.you_win.connect(on_win)
#func _ready():
#	call_deferred("cheats")
#
func _process(delta):
	if !OS.is_debug_build():
		return
	if Input.is_key_pressed(KEY_1):
		acquire_map(0)
	if Input.is_key_pressed(KEY_2):
		acquire_map(1)
	if Input.is_key_pressed(KEY_3):
		acquire_map(2)
	if Input.is_key_pressed(KEY_4):
		acquire_map(3)
	
func pickup(item: Pickup):
	if inventory.has(item):
		inventory[item] += 1
	else:
		inventory[item] = 1
	on_inventory_update.emit()
	on_pickup.emit(item)

func has_item(item: Pickup, count = 1) -> bool:
	return inventory.has(item) && inventory[item] >= count
		
func delete_item(item: Pickup, count = 1):
	if inventory.has(item):
		on_delete_item.emit(item, count)
		inventory[item] -= count
		if inventory[item] <= 0:
			inventory.erase(item)
		on_inventory_update.emit()
	
func acquire_map(i: int) -> void:
	if map_pieces[i]:
		return
	map_pieces[i] = true
	on_acquire_map.emit(i)

signal on_acquire_map(i: int)
signal on_inventory_update
signal on_pickup(item: Pickup)
signal on_delete_item(item: Pickup, count: int)
