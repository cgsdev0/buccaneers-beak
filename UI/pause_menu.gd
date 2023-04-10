extends Control


var animating_map = false
var animated = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var prev_mouse_mode = Input.MOUSE_MODE_CAPTURED
func _input(event):
	if event.is_action_pressed("pause"):
		if animating_map:
			return
		self.visible = !self.visible
		get_tree().paused = !get_tree().paused
		if visible:
			$OpenMap.play()
			check_map()
			prev_mouse_mode = Input.mouse_mode
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			$CloseMap.play()
			Input.mouse_mode = prev_mouse_mode
		
func check_map():
	if GameState.is_map_complete() && !animated:
		animated = true
		animating_map = true
		$AnimationPlayer.play("map_complete")
		await $AnimationPlayer.animation_finished
		animating_map = false

# sensitivity
func _on_h_slider_value_changed(value):
	GameState.sensitivity = value / 2.0


func _on_h_slider_2_value_changed(value):
	if value == -20.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("sfx"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("sfx"), value)


func _on_h_slider_3_value_changed(value):
	if value == -20.0:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), true)
	else:
		AudioServer.set_bus_mute(AudioServer.get_bus_index("music"), false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), value)
