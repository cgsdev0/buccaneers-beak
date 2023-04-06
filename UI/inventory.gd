extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_inventory_update.connect(update_inventory)


func update_inventory():
	print(GameState.inventory)
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for key in GameState.inventory:
		var item = Label.new()
		item.text = GameState.item_names[key]
		item.text = str(GameState.inventory[key]) + "x " + item.text
		add_child(item)
