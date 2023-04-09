extends Control


var data

var type_timer

func _ready():
#	$%ConfirmIcon.get_node("AnimationPlayer").play("flash")
	$%ConfirmIcon/AnimationPlayer.play("flash")
	type_timer = Timer.new()
	add_child(type_timer)
	visible = false
	Story.dialogue.connect(on_dialogue)
	# on_dialogue("hi", { "text": ["hey how is it going this is a longer text"]})

var i = 0

var typing = false

func on_resize():
	$%DialogueLabel.bbcode_text = state
	
func get_text(msg):
	var text = "uhhhh oh... my creator messed up >.<"
	if typeof(msg) == TYPE_STRING:
		text = msg
	elif typeof(msg) == TYPE_DICTIONARY:
		text = msg.text
	return text
	
func strip_bbcode(source: String) -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(source, "", true)
	
var state = ""

func on_dialogue(char, data):
#	Game.block_interaction = true
#	Tutorial.in_dialogue = true

	if data.has("trigger"):
		Story.dialogue_event.emit(data.trigger)
		
	if data.has("portrait"):
		$%Portrait.texture.atlas = Story.get_portrait(char)[data.portrait]
	else:
		$%Portrait.texture.atlas = Story.get_portrait(char)[0]
	
	var voice = Story.get_voice(char)
	var typewriter = voice[1]
		
	var temp: Array[AudioStream] = []
	for v in voice[0]:
		temp.push_back(v)
		
		
	$SpeechSound.samples = temp
		
	if data.has("delay"):
		await get_tree().create_timer(data.delay).timeout
		
	self.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if "input" in data:
		$%ConfirmIcon.hide()
		$%Character.hide()
		for option in data.input:
			var btn = Button.new()
			btn.text = option.text
			var onclick = func():
				for child in $%Player.get_children():
					child.queue_free()
				go_next(char, option)
			$%Player.add_child(btn)
			btn.pressed.connect(onclick)
		$%Player.get_child(0).grab_focus()

	elif "text" in data:
		$%Character.show()
		while !data.text.is_empty():
			$%ConfirmIcon.hide()
			var next = data.text.pop_front()
			if typeof(next) == TYPE_STRING || typeof(next) == TYPE_DICTIONARY && next.get("clear", true):
				$%DialogueLabel.visible_characters = 0
				$%DialogueLabel.clear()
				state = ""
			$%DialogueLabel.append_text(get_text(next))
			state += get_text(next)
			
			$AnimationPlayer.play("talk")
			call_deferred("type_message", next, i, typewriter)
			await self.done_typing_or_confirmed
			$%DialogueLabel.visible_characters = $%DialogueLabel.get_total_character_count()
			typing = false
			# $"%Friend".bounce()

			i += 1

			$"%ConfirmIcon".show()
			await self.confirm
		
		go_next(char, data)

func go_next(char, data):
	if "next" in data:
			Story.trigger(char, data.next)
	else:
		self.visible = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	#	Game.block_interaction = false
	#	Tutorial.in_dialogue = false
		Story.finish_dialogue.emit(char)
			
func _process(delta):
	if Input.is_action_just_pressed("dialogue_confirm"):
		if typing:
			self.done_typing_or_confirmed.emit()
		else:
			self.confirm.emit()
		
func type_message(msg, i, typewriter):
	var stripped = strip_bbcode(state)
	var stung = false
	typing = true
	for j in range($%DialogueLabel.visible_characters, $%DialogueLabel.get_total_character_count()):
		if self.i != i:
			return
		if !$SpeechSound.playing && (typewriter || !stung):
			stung = true
			$SpeechSound.play_random()
		$%DialogueLabel.visible_characters += 1
		if stripped[j] == ",":
#			$"%Friend".bounce()
			type_timer.start(0.2)
		elif stripped[j] in ".?!;:,":
#			$"%Friend".bounce()
			type_timer.start(0.4)
		else:
			$AnimationPlayer.play("talk")
			type_timer.start(0.04)
		await type_timer.timeout
	if self.i == i:
		self.done_typing_or_confirmed.emit()

signal confirm
signal done_typing_or_confirmed
