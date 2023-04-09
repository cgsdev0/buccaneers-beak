extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_pickup.connect(on_pickup)
	GameState.on_acquire_map.connect(on_map)


func on_pickup(item: GameState.Pickup):
	$PickupItem.play()
	
func on_map(i: int):
	$PickupMap.play()
