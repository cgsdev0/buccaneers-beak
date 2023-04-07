class_name InventoryHint extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	add_theme_color_override("font_outline_color", Color("#282828"))
	add_theme_constant_override("outline_size", 8)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5).set_delay(4.0)
	await tween.finished
	queue_free()
