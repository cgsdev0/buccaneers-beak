extends Node

enum Track {
	MIMIC,
	SAILING,
	TALKING
}
var current_tween = null
func fade_out(duration: float = 2.0):
	if current_tween != null:
		await current_tween.finished
	for child in get_children():
		if child.playing:
			(child.stream as AudioStreamMP3).loop = false
			var tween = get_tree().create_tween()
			current_tween = tween
			tween.set_parallel()
			tween.tween_property(child, "volume_db", -50.0, 2.0)
			await tween.finished
			child.stop()
			(child.stream as AudioStreamMP3).loop = true
			break
	current_tween = null
			
func _start_track(player: AudioStreamPlayer):
	if player.playing:
		return
	if current_tween != null:	
		await current_tween.finished
	for child in get_children():
		if child.playing:
			(child.stream as AudioStreamMP3).loop = false
			var tween = get_tree().create_tween()
			current_tween = tween
			tween.set_parallel()
			tween.tween_property(child, "volume_db", -50.0, 2.0)
			var initial = player.volume_db
			player.volume_db = -50.0
			tween.tween_property(player, "volume_db", initial, 2.0)
			player.play()
			await tween.finished
			child.stop()
			(child.stream as AudioStreamMP3).loop = true
			break
	player.play()
		
func start_track(track: Track):
	match track:
		Track.MIMIC:
			_start_track($Mimic)
		Track.SAILING:
			_start_track($Sailing)
		Track.TALKING:
			_start_track($Talking)
