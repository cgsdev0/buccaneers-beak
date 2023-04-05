extends Node

enum Character {
	CAPTAIN_AVERY,
	PARROT
}

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
		"ENTRY": { "text": ["hello :)"], "next": "continued" },
		"continued": { "input": [
				{ "text": "hey!", "next": "fuck_you" },
				{ "text": "I have to go." }
		] },
		"fuck_you": { "text": [ "eat shit and die" ] }
	}
}

func trigger(char: Character, entry = "ENTRY"):
	self.dialogue.emit(char, lines[char][entry].duplicate(true))

signal dialogue(char: Character, data)
signal finish_dialogue(char: Character)
signal enable_interaction(e: bool)
