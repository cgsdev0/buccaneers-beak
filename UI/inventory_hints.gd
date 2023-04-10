extends VBoxContainer


var total = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_pickup.connect(on_pickup)
	GameState.on_delete_item.connect(on_delete)
	GameState.on_acquire_map.connect(on_map)
	call_deferred("count_shells")
	
func count_shells():
	total = get_tree().get_nodes_in_group("seashell").size()
	
func on_pickup(item: GameState.Pickup):
	var hint = InventoryHint.new()
	hint.text = "+1 " + GameState.item_names[item]
	if item == GameState.Pickup.SHELL:
		hint.text = str(GameState.inventory[GameState.Pickup.SHELL]) + "/" + str(total) + " Hidden Seashells Found!"
	add_child(hint)
	
func on_map(i: int):
	var hint = InventoryHint.new()
	hint.text = "+1 Map Piece"
	add_child(hint)

func on_delete(item: GameState.Pickup, count: int):
	var hint = InventoryHint.new()
	hint.text = str(-count) + " " + GameState.item_names[item]
	hint.modulate = Color.RED
	add_child(hint)
