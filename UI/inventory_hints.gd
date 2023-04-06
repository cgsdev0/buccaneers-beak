extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_pickup.connect(on_pickup)
	GameState.on_delete_item.connect(on_delete)
	GameState.on_acquire_map.connect(on_map)
	
func on_pickup(item: GameState.Pickup):
	var hint = InventoryHint.new()
	hint.text = "+1 " + GameState.item_names[item]
	hint.modulate = Color.RED
	add_child(hint)
	
func on_map(i: int):
	var hint = InventoryHint.new()
	hint.text = "+1 Map Piece"
	add_child(hint)

func on_delete(item: GameState.Pickup, count: int):
	var hint = InventoryHint.new()
	hint.text = str(-count) + " " + GameState.item_names[item]
	add_child(hint)
