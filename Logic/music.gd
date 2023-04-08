extends Node

enum Track {
	MIMIC,
	SAILING,
	TALKING
}
var current_tween = null

func _ready():
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		child.finished.connect(on_finish)

func on_finish():
	pass # TODO: play some ambient sounds
		
func stop_looping():
	if current_tween != null:
		await current_tween.finished
		await get_tree().process_frame
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		if child.playing:
			(child.stream as AudioStreamMP3).loop = false
	current_tween = null
	
func stop_looping_if_playing(track: Track):
	if current_tween != null:
		return
	var player = get_player(track)
	if !player.playing:
		return
	(player.stream as AudioStreamMP3).loop = false
	
func fade_out(duration: float = 2.0):
	if current_tween != null:
		await current_tween.finished
		await get_tree().process_frame
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		if child.playing:
			(child.stream as AudioStreamMP3).loop = false
			var tween = get_tree().create_tween()
			current_tween = tween
			tween.set_parallel()
			tween.tween_property(child, "volume_db", -50.0, 2.0)
			await tween.finished
			child.stop()
			break
	current_tween = null
			
func start_track(track: Track):
	var player = get_player(track)
	if player.playing:
		(player.stream as AudioStreamMP3).loop = true
		return
	if current_tween != null:	
		await current_tween.finished
		await get_tree().process_frame
	var started = false
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		if child.playing:
			started = true
			(child.stream as AudioStreamMP3).loop = false
			var tween = get_tree().create_tween()
			current_tween = tween
			tween.set_parallel()
			tween.tween_property(child, "volume_db", -50.0, 2.0)
			player.volume_db = -50.0
			tween.tween_property(player, "volume_db", player.initial_db, 2.0)
			(player.stream as AudioStreamMP3).loop = true
			player.play()
			await tween.finished
			child.stop()
			break
	if !started:
		player.play()
	current_tween = null
	
func get_player(track: Track):
	match track:
		Track.MIMIC:
			return $Mimic
		Track.SAILING:
			return $Sailing
		Track.TALKING:
			return $Talking
