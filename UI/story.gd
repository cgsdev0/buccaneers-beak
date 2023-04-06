extends Node

enum Character {
	CAPTAIN_AVERY,
	PARROT,
	CRAB,
	GOAT
}

enum Trigger {
	GOAT_TRADE
}

func get_portrait(char: Character):
	match char:
		Character.CAPTAIN_AVERY:
			return [preload("res://Characters/Portraits/captain_avery.png")]
		Character.PARROT:
			return [preload("res://Characters/Portraits/parrot.png")]
		Character.CRAB:
			return [preload("res://Characters/Portraits/crab.png")]
		Character.GOAT:
			return [preload("res://Characters/Portraits/goat2.png"), preload("res://Characters/Portraits/goat3.png")]
			
var templates = {
		"a": { "next": "", "text": [] },
		"b": { "input": [ 
			{ "text": "", "next": "" }
		] },
}
var lines = {
	Character.CAPTAIN_AVERY: {
		"find_it_yet": { "text": [ "You find that treasure yet?" ]},
		"ENTRY": { "next": "2", "text": [ "Ahoy there, matey! Ye be lookin' for the treasure of [wave]Captain Blackbeard[/wave], I reckon?" ] },
		"2": { "input": [ 
			{ "text": "Yes, of course I am.", "next": "skip" },
			{ "text": "The what?", "next": "details_prompt" }
		] },
		"details_prompt": { "next": "confirm", "text": [ "Hah, you haven't heard of the lost treasure of Captain Blackbeard?" ] },
		"confirm": { "input": [ 
			{ "text": "Of course I have!", "next": "skip" },
			{ "text": "No...", "next": "details" }
		] },
		"details": { "next": "end_details", "text": [
			"Ah, yes. Captain Blackbeard's lost treasure. It's said to be the greatest hoard of riches ever amassed by a pirate. Gold, silver, jewels, you name it.",
			"Blackbeard spent years plundering ships along the eastern coast of the Americas and the Caribbean, and he stashed his loot in a secret location before he was killed."
		] },
		"end_details": { "input": [ 
			{ "text": "I'm interested.", "next": "skip" },
		] },
		"skip": { "next": "where", "text": [
			{ "text": "Good on ye! " },
			{ "clear": false, "text": "Rumor has it that Blackbeard entrusted the location of his treasure to his most trusted crew members, who each had a piece of the map."},
			"They all disappeared soon after Blackbeard's death, and the map pieces were scattered across the islands.",
			"It's taken many years and many adventurers to collect all the pieces, but none have been successful in finding the treasure."
		] },
		"where": { "input": [ 
			{ "text": "Where can I find the map?", "next": "start" }
		] },
		"start": { "text": [ "You can start here, matey. [i](pulls out a crumpled map)[/i]",
		"I've had this piece of the map for years, but I'm 'fraid I'm too old for treasure hunting these days.",
		"Just promise to remember ol' Captain Avery if you find that treasure!" ] },
	},
	Character.PARROT: {
		"get_map_0": { "text": ["Squawk! Whaddya lookin' at? Keep movin'! Squawk!"] },
		"join_forces": { "text": ["caw"], "next": "continued" },
		"continued": { "input": [
				{ "text": "where we droppin", "next": "follow_me" },
		] },
		"follow_me": { "text": [ "follow me!" ] }
	},
	Character.CRAB: {
		"ENTRY": { "text": ["have you tried rewriting it in rust?"] },
		"join_forces": { "text": ["caw"], "next": "continued" },
		"continued": { "input": [
				{ "text": "where we droppin", "next": "follow_me" },
		] },
		"follow_me": { "text": [ "follow me!" ] }
	},
	Character.GOAT: {
		"ENTRY": { "text": ["trade for that pipe"], "next": "ok" },
		"ok": { "input": [
				{ "text": "(give pipe)", "next": "nice" },
		] },
		"nice": { "text": ["nice"], "portrait": 1, "trigger": Trigger.GOAT_TRADE },
		"follow_me": { "text": [ "follow me!" ] }
	}
}

func trigger(char: Character, entry = "ENTRY"):
	enable_interaction.emit(false)
	self.dialogue.emit(char, lines[char][entry].duplicate(true))

signal dialogue_event(trigger: Trigger)
signal dialogue(char: Character, data)
signal finish_dialogue(char: Character)
signal enable_interaction(e: bool)
