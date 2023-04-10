extends Node3D

var out = true
var interactable = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("breathe")

func _input(event):
	if out || Story.in_dialogue:
		return
	if event.is_action_pressed("interact"):
		if !GameState.has_all_shells:
			Music.start_track(Music.Track.TALKING)
			$CameraController.active = true
			Story.trigger(Story.Character.CAPYBARA)
			$Arrow.visible = false
			await Story.finish_dialogue
			$CameraController.previous_camera()
			Music.stop_looping()
		else:
			$CameraController.active = true
			Story.trigger(Story.Character.CAPYBARA, "you_did_it")
			await Story.finish_dialogue
			$CameraController.previous_camera()

func _on_area_3d_body_entered(body):
	Story.enable_interaction.emit(Story.Character.CAPYBARA)
	out = false


func _on_area_3d_body_exited(body):
	Story.disable_interaction.emit()
	out = true


