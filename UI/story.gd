extends Node

enum Character {
	CAPTAIN_AVERY,
	PARROT,
	CRAB,
	GOAT,
	MIMIC
}

enum Trigger {
	GOAT_TRADE,
	CRAB_MAP
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
		Character.MIMIC:
			return [preload('res://Characters/Portraits/mimic.png')]

var templates = {
		"a": { "next": "", "text": [] },
		"b": { "input": [
			{ "text": "", "next": "" }
		] },
}
var lines = {
	Character.MIMIC: {
		"exposition": { "next": "dont", "text": ["Surprise! You thought I was just a chest, didn't you? Well, I'm not. I'm a mimic, and I love eating adventurers like you!"] },
		"dont": { "input": [
			{ "text": "Wait! Don't eat me!", "next": "why_not" }
		] },
		"why_not": { "next": "because", "text": ["[i](laughs)[/i] I'm sorry deary, but I'm afraid I must. I haven't eaten an adventurer in weeks! Why, you'd think I was on a diet it's been so long!"] },
		"because": { "input": [
			{ "text": "(lie) I'm poisonous.", "next": "poison" },
			{ "text": "(lie) But I'm famous!", "next": "fame" },
			{ "text": "I could... tell you a story?", "next": "story" },
		] },
		"fame": { "next": "because", "text": ["Bless your heart, I'm afraid that just makes you more scrumptious! In fact, I've eaten lots of famous folks. Pirates, actors... sometimes I [i]do[/i] wonder if it's too rich, you know what I mean?"] },
		"poison": { "next": "not_poison", "text": ["...that's funny. You don't [i]look[/i] poisonous. Now how do I know you're not just pullin' the wool over my peepers?"] },
		"not_poison": { "input": [
			{ "text": "Because... well, uh...", "next": "stumble" },
			{ "text": "(lie) I bathe in snake venom.", "next": "immune" },
		] },
		"stumble": { "next": "because", "text": ["Aren't you just the most [i]adorable[/i] liar. Anyways, if that's all, I suppose we should get on with it..."] },
		"immune": { "next": "because", "text": ["Oh, what a relief! I've eaten plenty of snakes before. I think I've built up something of an immunity to the venom.", "Now be a dear and come over here, I'll make it quick and painless!"] },
		"story": { "next": "continue", "text": ["Well, I suppose I could wait a little longer. Dinner [i]and[/i] a story? You're such a little darling!"] },
		"continue": { "input": [
			{ "text": "I met a talking parrot", "next": "storyA" },
			{ "text": "I'm on a quest for Blackbeard's treaure", "next": "storyB" },
		] },
		"continue2": { "input": [
			{ "text": "I'm on a quest for Blackbeard's treaure", "next": "storyB" },
		] },
		"storyA": { "next": "A2", "text": ["Not much of a story, but I'm happy for you!", "Now pardon me but, I don't meet many parrots - as you can imagine; but is that something special?"] },
		"A2": { "input": [
			{ "text": "Well... it's complicated", "next": "A3" }
		] },
		"A3": { "next": "continue2", "text": ["I see. Was that... the end of the story?"] },
		"storyB": { "next": "B2", "text": ["Blackbeard you say? Well, now THAT'S a funny coincidence.", "I had a snack just last week who was mumbling about some Captain Blackbeard.", "It really is a small world we live in!"] },
		"B2": { "input": [
			{ "text": "Really? What did they say?", "next": "B3" }
		] },
		"B3": { "next": "B4", "text": ["Treasure this, treasure that... something about a map? I'm sorry dear but things like that are hard to remember. They were SO boring.", "Not like you! I've enjoyed your company. I have to admit, I'll be a little sad to eat you. Oh well!"] },
		"B4": { "input": [
			{ "text": "A map? Like this one? (show map)", "next": "B5A" },
			{ "text": "You have a map? Can I see it?", "next": "B5B" },
		] },
		"B4_2": { "input": [
			{ "text": "A map? Like this one? (show map)", "next": "B5A" },
		] },
		"B5B": { "next": "B4_2", "text": ["Sure, why don't you just come a little closer dearie... that's it just a teeny bit more... [i](licks lips)[/i]"] },
		"B5A": { "next": "funny", "text": ["Huh. Exactly like that one! I still have it. Where do you adventurers get all these maps, anyways?"] },
		"funny": { "input": [
			{ "text": "I got it from Captain Avery.", "next": "eureka" }
		] },
		"eureka": { "next": "map_pls", "text": ["[shake]CAPTAIN AVERY?![/shake] Why didn't you say so! I used to live on his ship!!! Doesn't he just have the most adorable smile?",
	"Oh, well if you're Avery's friend, then it really would be such a shame to eat you. Okay, I think I'll let you live."
	] },
		"map_pls": { "input": [
			{ "text": "Can I have the map?", "next": "yes_map" }
		] },
		"yes_map": { "text": ["Sure, I don't see why not. It's not like I have any use for it!"] },
		"closer": { "text": ["Tell Avery I said hello, would you please my dear?"] },
	},
	Character.CRAB: {
		"exposition": { "next": "got_treasure", "text": ["What do you want? Can't you see I'm busy here?"] },
		"got_treasure": { "input": [
			{ "text": "I'm looking for a map piece.", "next": "oh_great" }
		] },
		"oh_great": { "next": "offer", "text": [ "Oh, great. Another human after my treasures. What makes you think I would just hand it over to you?"] },
		"offer": { "input": [
			{ "text": "Because... you're a great guy?", "next": "laugh" },
			{ "text": "Maybe we can make a deal.", "next": "deal" }
		] },
		"offer2": { "input": [
			{ "text": "Maybe we can make a deal.", "next": "deal" }
		] },
		"laugh": { "next": "offer2", "text": [ "Hah! You make me laugh.", "...I hate laughing." ] },
		"deal": { "next": "negotiate", "text": ["Hmph. I suppose it's worth hearing what you have to offer. But don't expect me to just give it to you."] },
		"negotiate": { "input": [
			{ "text": "I know crabs like shiny things.", "next": "try_again" },
			{ "text": "I could bring you some... fruit?", "next": "yes_please" },
		] },
		"negotiate2": { "input": [
			{ "text": "I could bring you some... fruit?", "next": "yes_please" },
		] },
		"try_again": { "next": "negotiate2", "text": ["Shiny objects? Bah! I have enough of those. You'll have to come up with something better than that if you want my map piece."] },
		"yes_please": { "text": [
			"Now you're talking. I do love a good meal. Bring me a feast fit for a king, and we'll talk more about that map piece. But don't try to trick me, human. I have a keen eye for deceit.",
			"Gather at least [b][color=yellow]5 apples[/color][/b] from the surrounding islands, and bring them to me."
			] },
		"not_enough_apples": {
			"next": "q1", "text": [
				"Back so soon? Do you have my apples?"
			],
		},
		"go_away": {
			"text": [
				"Then we have nothing to discuss."
			],
		},
		"enough_apples": {
			"next": "q2", "text": [
				"Back so soon? Do you have my apples?"
			],
		},
		"q1": { "input": [
			{ "text": "No", "next": "go_away" }
		] },
		"q2": { "input": [
			{ "text": "(give apples)", "next": "trade_for_map" },
			{ "text": "No", "next": "go_away" },
		] },
		"trade_for_map": {
			"trigger": Trigger.CRAB_MAP, "next": "thanks", "text": [
				"Hmm, not bad. I suppose this will suffice.",
				"Very well, I'll give it to you as promised. But remember, this is just the beginning of your journey. If you wish to find the treasure of Captain Blackbeard, you'll need to keep your wits about you and be prepared for any challenges that come your way."
			],
		},
		"thanks": { "input": [
			{ "text": "Thank you!", "next": "dont_mention_it" },
			{ "text": "Goodbye." },
		] },
		"dont_mention_it": { "text": ["Don't mention it. Now be off with you, before I change my mind. And don't forget to bring me more apples next time you visit!"] },
		"safe_travels": { "text": ["Safe travels, friend."]}
	},
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
		"explain_map_1": { "text": ["Squawk! Where'd you get that map, hey?"], "next": "continued" },
		"continued": { "input": [
				{ "text": "I got it from Captain Avery.", "next": "not_the_first" },
		] },
		"not_the_first": { "next": "who", "text": [
			"A treasure hunter, eh? You're not the first, you know. My old captain had to deal with [i]dozens[/i] of you lot back in the day.",
			"Always poking around, trying to get your grubby hands on his treasure."
		]},
		"who": { "input": [
				{ "text": "Your old captain?", "next": "blackbeard" },
				{ "text": "Can you help me find the treasure?", "next": "treasure" },
		] },
		"who2": { "input": [
				{ "text": "Can you help me find the treasure?", "next": "treasure" },
		] },
		"blackbeard": { "next": "who2", "text": [
			"Captain Blackbeard. Y'know, the one who [i]wrote that map you're holding?[/i]"
		]},
		"treasure": { "next": "next_map", "text": [
			"Oh, I suppose I could. After all, I know more about treasure than you do. But let's get one thing straight: I'm not doing this for you. I'm doing it because it's what my captain would have wanted."
		]},
		"next_map": { "input": [
				{ "text": "Do you know where the other map pieces are?", "next": "rough_idea" },
		] },
		"rough_idea": { "text": [ "I have a rough idea. Hop in that boat and follow me. Or don't, what do I care?" ] },
		"get_map_1": { "text": ["Go talk to the ol' crab hermit. I think he has one of the map pieces."] },
		"explain_map_2": { "text": ["Well well well, if it isn't my favorite bumbling treasure hunter. I hope you're ready for your next adventure, because you're not getting any younger. Or smarter, for that matter.",
	"There's a cave nearby that has a... chest, which.. well, [i]contains[/i] the next piece of the map. Hopefully. I think.",
	"This one's not going to be such a walk in the park. Good luck, you'll need all the wit and charm you can muster.",
	"Anyway... follow me!"] },
		"get_map_2": { "next": "follow_up_map_2", "text": ["Squawk! Alright, we're here. Keep your eyes peeled for anything suspicious. Who knows what kind of obstacles we might encounter behind that waterfall.", "[i](sheepishly)[/i] [shake]...I'll wait here. Somebody's gotta watch the boat, right?[/shake]",] },
		"follow_up_map_2": { "input": [
			{ "text": "Why are you acting so suspicious?", "next": "feathers" },
			{ "text": "Makes sense to me." },
		] },
		"feathers": { "next": "", "text": ["Squawk! I just don't like getting my feathers wet, okay?!"] },
		"explain_map_3": { "text": ["How uh... how did it go in there? Squawk!"], "next": "hate" },
		"hate": { "input": [
			{ "text": "I hate you.", "next": "hate2" }
		] },
		"hate2": { "next": "hate3", "text": ["Look, if I told you about the mimic, would you have still gone in?"] },
		"hate3": { "input": [
			{ "text": "Yes.", "next": "crazy" },
			{ "text": "No...", "next": "what_i_thought" },
		] },
		"crazy": { "next": "anywho", "text": ["Huh. You're crazier than I thought. "] },
		"what_i_thought": { "next": "anywho", "text": ["That's what I thought! "] },
		"anywho": { "text": [{ "text": "Anywho, the last map piece is on a mountain island. It's a treacherous place, with steep cliffs and dangerous wildlife.", "clear": false}, "We have to sail back out the way we came, and then you can just follow me. Onwards!"] },
		"get_map_3": { "text": ["If I remember correctly, the last map piece is just in that chest up the road. Easy peasy, squawk!"] },
		"explain_map_4": { "text": ["Wow, you've done it! You've found all the pieces and put them together! This is truly exciting.",
	"Let me take a look at that map... Ah, yes, I see it now. Well, you know the drill - follow me!"
	] },
		"get_map_4": { "text": ["Squawk! No one has set foot in that cave since Blackbeard disappeared...", "Surely there wouldn't be any traps [i]here[/i], right?", "...But just to be safe, you go first; I'll wait on the boat."] },
	},
	Character.GOAT: {
		"tell_your_friends": { "text": ["Would you mind telling people in town about my store? I don't get many customers up here..."] },
		"no_pipe": { "text": ["Look, I'm not giving up the map until you get me [b][color=green]my pipe[/color][/b]!"] },
		"ENTRY": { "text": ["Did you find [b][color=green]my pipe[/color][/b]?"], "next": "ok" },
		"ok": { "input": [
				{ "text": "(give pipe)", "next": "nice" },
				{ "text": "(lie) no", "next": "not_nice"}
		] },
		"not_nice": { "text": ["Then I'm gonna keep munchin'!"] },
		"nice": { "text": ["[i](puffs)[/i] Ahhh... thank you. Here, take your stupid map. It didn't taste good anyways."], "portrait": 1, "trigger": Trigger.GOAT_TRADE },
		"exposition": { "next": "not_food", "text": [
			"[i](chewing loudly)[/i] Mmm, this is delicious! I've been searching for a good meal all day."
		] },
		"not_food": { "input": [
				{ "text": "Stop! That's not food!", "next": "yes_it_is" },
		] },
		"yes_it_is": { "next": "i_need", "text": [
			"Oh, I know what it is. But I'm also pretty sure it's food. Everything's food if you're determined enough!"
		] },
		"i_need": { "input": [
				{ "text": "Please, can I have the map?", "next": "no_interest" },
				{ "text": "Hand it over!", "next": "no_interest" },
		] },
		"no_interest": { "next": "trade", "text": [
			"Sorry, kid. This map piece is mine now. And I'm gonna eat every last crumb of it!"
		] },
		"trade": { "input": [
				{ "text": "How about a trade?", "next": "find_my_pipe" },
		] },
		"find_my_pipe": { "text": [
			"Hmm... [i]well....[/i]",
			{ "text": "If you can find [b][color=green]my pipe[/color][/b], I suppose I'd be willing to give up the paper. I lost it somewhere on the island.", "clear": false}
		] }
	}
}

var in_dialogue = false
func trigger(char: Character, entry = "ENTRY"):
	disable_interaction.emit()
	var was_in_dialogue = in_dialogue
	in_dialogue = true
	self.dialogue.emit(char, lines[char][entry].duplicate(true))
	if !was_in_dialogue:
		await self.finish_dialogue
		in_dialogue = false

signal dialogue_event(trigger: Trigger)
signal dialogue(char: Character, data)
signal finish_dialogue(char: Character)
signal enable_interaction(char: Character)
signal disable_interaction()
signal enable_boat_interaction()
signal disable_boat_interaction()
signal enable_boat_exit_interaction()
signal disable_boat_exit_interaction()
signal enable_door_interaction
signal disable_door_interaction
signal you_win
