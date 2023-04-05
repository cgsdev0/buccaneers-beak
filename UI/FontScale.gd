extends Control


func screen_scale():
	return min(get_window().size.x / 1920.0, get_window().size.y / 1080.0)


func _process(delta):
	get_theme().default_font_size = max(12, round(36 * screen_scale()))
