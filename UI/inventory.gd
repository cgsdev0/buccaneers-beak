extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.on_pickup.connect(update_inventory)
	GameState.on_delete_item.connect(update_inventory)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_inventory(_k):
	print(GameState.inventory)
	for child in get_children():
		remove_child(child)
		child.queue_free()
	for key in GameState.inventory:
		var item = Label.new()
		item.text = GameState.item_names[key]
		item.text = str(GameState.inventory[key]) + "x " + item.text
		add_child(item)
