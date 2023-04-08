extends Node3D

var out = true
var exposition = false
var complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("breathe")
	Story.dialogue_event.connect(on_trigger)

func on_trigger(trigger: Story.Trigger):
	match trigger:
		Story.Trigger.GOAT_TRADE:
			complete = true
			$%map.hide()
			$%Pipe.show()
			$%Pipe/GPUParticles3D.emitting = true
			GameState.acquire_map(3)
			GameState.delete_item(GameState.Pickup.PIPE)
			
func _input(event):
	if out || Story.in_dialogue:
		return
	if event.is_action_pressed("interact"):
		if exposition:
			if complete:
				$CameraController.active = true
				Story.trigger(Story.Character.GOAT, "tell_your_friends")
				await Story.finish_dialogue
				$CameraController.previous_camera()
			elif GameState.has_item(GameState.Pickup.PIPE):
				$CameraController.active = true
				Story.trigger(Story.Character.GOAT)
				$Arrow.visible = false
				await Story.finish_dialogue
				$CameraController.previous_camera()
			else:
				$CameraController.active = true
				Story.trigger(Story.Character.GOAT, "no_pipe")
				await Story.finish_dialogue
				$CameraController.previous_camera()
		else:
			exposition = true
			$CameraController.active = true
			Story.trigger(Story.Character.GOAT, "exposition")
			await Story.finish_dialogue
			$CameraController.previous_camera()

func _on_area_3d_body_entered(body):
	Story.enable_interaction.emit(Story.Character.GOAT)
	out = false


func _on_area_3d_body_exited(body):
	Story.disable_interaction.emit()
	out = true
