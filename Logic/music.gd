extends Node

enum Track {
	MIMIC,
	SAILING,
	TALKING,
	FINALE,
	STINGER
}
var current_tween = null

func _ready():
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		child.finished.connect(on_finish)

func on_finish():
	finished.emit()
	pass # TODO: play some ambient sounds
		
func stop_looping():
	if current_tween != null:
		await current_tween.finished
		await get_tree().process_frame
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		if child.playing:
			set_loop(child, false)
	current_tween = null
	
func play_from(track: Track, position: float): # 0.6231429010032888
	var player = get_player(track)
	set_loop(player, false)
	player.volume_db = player.initial_db
	player.play()
	player.seek(position)
	
func stop_looping_if_playing(track: Track):
	if current_tween != null:
		return
	var player = get_player(track)
	if !player.playing:
		return
	set_loop(player, false)
	
func fade_out(duration: float = 2.0):
	if current_tween != null:
		await current_tween.finished
		await get_tree().process_frame
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		if child.playing:
			set_loop(child, false)
			var tween = get_tree().create_tween()
			current_tween = tween
			tween.set_parallel()
			tween.tween_property(child, "volume_db", -50.0, duration)
			await tween.finished
			child.stop()
			break
	current_tween = null

func set_loop(player: AudioStreamPlayer, loop: bool) -> void:
	if is_instance_of(player.stream, AudioStreamMP3):
		player.stream.loop = loop
	elif is_instance_of(player.stream, AudioStreamWAV):
		if loop:
			player.stream.loop_mode = AudioStreamWAV.LoopMode.LOOP_FORWARD
		else:
			player.stream.loop_mode = AudioStreamWAV.LoopMode.LOOP_DISABLED
		
func play_stinger():
	$Node/Stinger.play()
func start_track(track: Track):
	var player = get_player(track)
	if player.playing && player.should_loop:
		set_loop(player, true)
		return
	if current_tween != null:
		await current_tween.finished
		await get_tree().process_frame
	var started = false
	for child in get_children():
		if not child is AudioStreamPlayer:
			continue
		if child.playing:
			if child == $Finale:
				return
			started = true
			set_loop(child, false)
			var tween = get_tree().create_tween()
			current_tween = tween
			tween.set_parallel()
			tween.tween_property(child, "volume_db", -50.0, 2.0)
			player.volume_db = -50.0
			tween.tween_property(player, "volume_db", player.initial_db, 2.0)
			if player.should_loop:
				set_loop(player, true)
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
		Track.FINALE:
			return $Finale
		Track.STINGER:
			return $Stinger

signal finished
