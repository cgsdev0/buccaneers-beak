extends Node3D

var out = true
var interactable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("breathe")

func _input(event):
	if out:
		return
	if event.is_action_pressed("interact"):
		if interactable:
			Story.enable_interaction.emit(false)
			$CameraController.active = true
			Story.trigger(Story.Character.CRAB)
			interactable = false
			$Arrow.visible = false
			await Story.finish_dialogue
			$CameraController.previous_camera()
		else:
			Story.enable_interaction.emit(false)
			$CameraController.active = true
			Story.trigger(Story.Character.CRAB)
			await Story.finish_dialogue
			$CameraController.previous_camera()

func _on_area_3d_body_entered(body):
	Story.enable_interaction.emit(true)
	out = false


func _on_area_3d_body_exited(body):
	Story.enable_interaction.emit(false)
	out = true
