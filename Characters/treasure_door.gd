extends Node3D

var out = true
var interactable = true

func _input(event):
	if out || Story.in_dialogue:
		return
	if event.is_action_pressed("interact"):
		if interactable:
			$CameraController.active = true
			Story.you_win.emit()
			interactable = false

func _on_area_3d_2_body_entered(body):
	print("OH GOD WHY")
	Story.enable_door_interaction.emit()
	out = false

func _on_area_3d_2_body_exited(body):
	Story.disable_door_interaction.emit()
	out = true
