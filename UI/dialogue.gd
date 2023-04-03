extends Control


var data

var type_timer

func _ready():
#	$%ConfirmIcon.get_node("AnimationPlayer").play("flash")
	type_timer = Timer.new()
	add_child(type_timer)
	on_dialogue("hi", { "text": ["hey how is it going this is a longer text"]})

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
func on_dialogue(line, data):
	self.data = data.duplicate(true)
#	Game.block_interaction = true
#	Tutorial.in_dialogue = true
	if data.has("delay"):
		await get_tree().create_timer(data.delay).timeout
		
	self.visible = true
	
	while !data.text.is_empty():
		# $%ConfirmIcon.hide()
		var next = data.text.pop_front()
		if typeof(next) == TYPE_STRING || typeof(next) == TYPE_DICTIONARY && next.get("clear", true):
			$%DialogueLabel.visible_characters = 0
			$%DialogueLabel.clear()
			state = ""
		$%DialogueLabel.append_text(get_text(next))
		state += get_text(next)
		
#		$"%Friend".speak()
		call_deferred("type_message", next, i)
		await self.done_typing_or_confirmed
		$%DialogueLabel.visible_characters = $%DialogueLabel.get_total_character_count()
		typing = false
		# $"%Friend".bounce()

		i += 1

		# $"%ConfirmIcon".show()
		await self.confirm
		
	self.visible = false
#	Game.block_interaction = false
#	Tutorial.in_dialogue = false
#	Tutorial.emit_signal("dialogue_finished", line)
		
func _process(delta):
	if Input.is_action_just_pressed("dialogue_confirm"):
		if typing:
			self.done_typing_or_confirmed.emit()
		else:
			self.confirm.emit()
		
func type_message(msg, i):
	var stripped = strip_bbcode(state)
	typing = true
	for j in range($%DialogueLabel.visible_characters, $%DialogueLabel.get_total_character_count()):
		if self.i != i:
			return
#		if !$SpeechSound.playing:
#			$SpeechSound.play()
		$%DialogueLabel.visible_characters += 1
		if stripped[j] == ",":
#			$"%Friend".bounce()
			type_timer.start(0.2)
		elif stripped[j] in ".?!;:,":
#			$"%Friend".bounce()
			type_timer.start(0.4)
		else:
#			$"%Friend".speak()
			type_timer.start(0.04)
		await type_timer.timeout
	if self.i == i:
		self.done_typing_or_confirmed.emit()

signal confirm
signal done_typing_or_confirmed
