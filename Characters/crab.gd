extends Node3D

var out = true
var exposition = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("breathe")
	Story.dialogue_event.connect(on_trigger)

func on_trigger(trigger: Story.Trigger):
	match trigger:
		Story.Trigger.CRAB_MAP:
			$%map.hide()
			GameState.acquire_map(1)
			GameState.delete_item(GameState.Pickup.APPLE, 5)

func _input(event):
	if out || Story.in_dialogue:
		return
	if event.is_action_pressed("interact"):
		if !exposition:
			Music.start_track(Music.Track.TALKING)
			$CameraController.active = true
			Story.trigger(Story.Character.CRAB, "exposition")
			$Arrow.visible = false
			await Story.finish_dialogue
			$CameraController.previous_camera()
			$Arrow.visible = true
			exposition = true
			Music.stop_looping()
		elif !GameState.map_pieces[1]:
			if GameState.has_item(GameState.Pickup.APPLE, 5):
				Music.start_track(Music.Track.TALKING)
				$CameraController.active = true
				Story.trigger(Story.Character.CRAB, "enough_apples")
				$Arrow.visible = false
				await Story.finish_dialogue
				$CameraController.previous_camera()
				Music.stop_looping()
			else:
				$CameraController.active = true
				Story.trigger(Story.Character.CRAB, "not_enough_apples")
				$Arrow.visible = false
				await Story.finish_dialogue
				$CameraController.previous_camera()
		else:
			$CameraController.active = true
			Story.trigger(Story.Character.CRAB, "safe_travels")
			$Arrow.visible = false
			await Story.finish_dialogue
			$CameraController.previous_camera()

func _on_area_3d_body_entered(body):
	Story.enable_interaction.emit(Story.Character.CRAB)
	out = false


func _on_area_3d_body_exited(body):
	Story.disable_interaction.emit()
	out = true
