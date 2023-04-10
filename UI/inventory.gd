extends VBoxContainer


var total = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_inventory_update.connect(update_inventory)
	call_deferred("count_shells")
	
func count_shells():
	total = get_tree().get_nodes_in_group("seashell").size()

func update_inventory():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for key in GameState.inventory:
		var item = Label.new()
		item.text = GameState.item_names[key]
		item.text = str(GameState.inventory[key]) + "x " + item.text
		if key == GameState.Pickup.SHELL:
			item.text = str(GameState.inventory[GameState.Pickup.SHELL]) + " / " + str(total) + " Seashells"
			if GameState.inventory[GameState.Pickup.SHELL] == total:
				item.modulate = Color.GREEN
		add_child(item)
