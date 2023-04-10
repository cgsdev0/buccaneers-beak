extends Node3D


var played = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func trigger_music():
	Music.play_stinger()
	Music.start_track(Music.Track.STINGER)
	await get_tree().create_timer(9.0).timeout
	Music.start_track(Music.Track.FINALE)

func _on_area_3d_body_entered(body):
	if GameState.next_map() != 4 || played:
		return
	Story.in_dialogue = true # block dialogue, or you can get stuck talking to parrot
	played = true
	trigger_music()
	$CameraController.active = true
	$level/AnimationPlayer.play("rise")
	await $level/AnimationPlayer.animation_finished
	$CameraController.previous_camera()
	Story.in_dialogue = false
