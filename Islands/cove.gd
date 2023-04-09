extends Node3D


var played = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func trigger_music():
	Music.start_track(Music.Track.STINGER)
	await Music.finished
	Music.start_track(Music.Track.FINALE)

func _on_area_3d_body_entered(body):
	if GameState.next_map() != 4 || played:
		return
	played = true
	trigger_music()
	$CameraController.active = true
	$level/AnimationPlayer.play("rise")
	await $level/AnimationPlayer.animation_finished
	$CameraController.previous_camera()
