extends Node3D

var out = true
var interactable = true

func set_occluder(v: bool) -> void:
	$"Sail Ship".visible = v
	
func _input(event):
	if out || Story.in_dialogue:
		return
	if event.is_action_pressed("interact"):
		if interactable:
			$CameraController.active = true
			Story.you_win.emit()
			interactable = false
			await Music.fade_out(1.0)
			Music.play_from(Music.Track.FINALE, 39.967)

func _on_area_3d_2_body_entered(body):
	Story.enable_door_interaction.emit()
	out = false

func _on_area_3d_2_body_exited(body):
	Story.disable_door_interaction.emit()
	out = true
