extends Node

enum Character {
	CAPTAIN_AVERY,
	PARROT
}

func get_portrait(char: Character):
	match char:
		Character.CAPTAIN_AVERY:
			return preload("res://Characters/Portraits/captain_avery.png")
		Character.PARROT:
			return preload("res://Characters/Portraits/parrot.png")
			
var lines = {
	Character.CAPTAIN_AVERY: {
		"ENTRY": { "text": ["hello :)"], "next": "continued" },
		"continued": { "input": [
				{ "text": "hey!", "next": "fuck_you" },
				{ "text": "I have to go." }
		] },
		"fuck_you": { "text": [ "eat shit and die" ] }
	},
	Character.PARROT: {
		"ENTRY": { "text": ["caw"], "next": "continued" },
		"continued": { "input": [
				{ "text": "where we droppin", "next": "follow_me" },
		] },
		"follow_me": { "text": [ "follow me!" ] }
	}
}

func trigger(char: Character, entry = "ENTRY"):
	self.dialogue.emit(char, lines[char][entry].duplicate(true))

signal dialogue(char: Character, data)
signal finish_dialogue(char: Character)
signal enable_interaction(e: bool)
