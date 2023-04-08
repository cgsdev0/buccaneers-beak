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
		if interactable:
			Music.start_track(Music.Track.TALKING)
			$CameraController.active = true
			Story.trigger(Story.Character.CAPTAIN_AVERY)
			interactable = false
			$Arrow.visible = false
			await Story.finish_dialogue
			$CameraController.previous_camera()
			GameState.acquire_map(0)
			Music.stop_looping()
		else:
			$CameraController.active = true
			Story.trigger(Story.Character.CAPTAIN_AVERY, "find_it_yet")
			await Story.finish_dialogue
			$CameraController.previous_camera()

func _on_area_3d_body_entered(body):
	Story.enable_interaction.emit(Story.Character.CAPTAIN_AVERY)
	out = false


func _on_area_3d_body_exited(body):
	Story.disable_interaction.emit()
	out = true
