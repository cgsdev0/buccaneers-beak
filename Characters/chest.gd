extends Node3D

var out = true
var interactable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("shake")

func _input(event):
	if out || Story.in_dialogue:
		return
	if event.is_action_pressed("interact"):
		if interactable:
			$CameraController.active = true
			Story.trigger(Story.Character.MIMIC, "exposition")
			interactable = false
			$Arrow.visible = false
			await Story.finish_dialogue
			$CameraController.previous_camera()
			GameState.acquire_map(2)
		else:
			$CameraController.active = true
			Story.trigger(Story.Character.MIMIC, "closer")
			await Story.finish_dialogue
			$CameraController.previous_camera()

func _on_area_3d_body_entered(body):
	Story.enable_interaction.emit(Story.Character.MIMIC)
	out = false


func _on_area_3d_body_exited(body):
	Story.disable_interaction.emit()
	out = true
