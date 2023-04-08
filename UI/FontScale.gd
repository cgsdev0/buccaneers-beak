extends Control


func screen_scale():
	return min(get_window().size.x / 1920.0, get_window().size.y / 1080.0)


func _process(delta):
	get_theme().default_font_size = max(12, round(36 * screen_scale()))
	if Input.is_action_just_pressed("dialogue_confirm"):
		if !waiting && $%EndSequence.visible:
			$%EndSequence/AnimationPlayer.play("RESET")
			$%EndSequence.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _ready():
	$%EndSequence.visible = false
	Story.you_win.connect(on_win)
	
var waiting = false
func on_win():
	if waiting:
		return
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$%EndSequence/AnimationPlayer.play("RESET")
	$%EndSequence.visible = true
	$%EndSequence/AnimationPlayer.play("ending")
	waiting = true
	await $%EndSequence/AnimationPlayer.animation_finished
