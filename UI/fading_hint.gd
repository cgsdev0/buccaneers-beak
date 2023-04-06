class_name InventoryHint extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(4.0)
	await tween.finished
	queue_free()
