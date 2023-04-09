class_name RandomAudioStreamPlayer extends AudioStreamPlayer

@export var samples: Array[AudioStream] = []
@export_enum("Pure", "No consecutive repetition", "Use all samples before repeat") var random_strategy = 0
@onready var base_volume = volume_db
@export_range(0.0, 80.0) var random_volume_range = 0.0
@onready var base_pitch = pitch_scale
@export_range(0.0, 4.0) var random_pitch_range = 0.0

var playing_sample_nb : int = -1
var last_played_sample_nb : int = -1 # only used if random_strategy = 1
var to_play = [] # only used if random_strategy = 2

# You can use playing_sample_nb to choose what sample to use
func play_random(from_position=0.0, playing_sample_nb=-1):
	var number_of_samples = len(samples)
	if number_of_samples > 0:
		if playing_sample_nb < 0:
			if number_of_samples == 1:
				playing_sample_nb = 0
			else:
				match random_strategy:
					1:
						playing_sample_nb = randi() % (number_of_samples - 1)
						if last_played_sample_nb == playing_sample_nb:
							playing_sample_nb += 1
						last_played_sample_nb = playing_sample_nb
					2:
						if len(to_play) == 0:
							for i in range(number_of_samples):
								if i != last_played_sample_nb:
									to_play.append(i)
							to_play.shuffle()
						playing_sample_nb = to_play.pop_back()
						last_played_sample_nb = playing_sample_nb
					_:
						playing_sample_nb = randi() % number_of_samples
			if random_volume_range != 0:
				super.set_volume_db(base_volume + (randf() - .5) * random_volume_range)
			if random_pitch_range != 0:
				super.set_pitch_scale(max(0.0001, base_pitch + (randf() - .5) * random_pitch_range))
		set_stream(samples[playing_sample_nb])
		super.play(from_position)

func set_volume(new_volume_db):
	super.set_volume_db(new_volume_db)
	base_volume = new_volume_db

func set_pitch(new_pitch):
	super.set_pitch_scale(max(0.0001, new_pitch))
	base_pitch = new_pitch
