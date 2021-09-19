extends Node

var interactions: int = 0
var total_interactions: int = 0

var time: float = 0
var do_time: bool = false

var delete_inputs: bool = false

func _ready():
	
	if delete_inputs:
		for action in InputMap.get_actions():
			if ! action.begins_with("ui"):
				InputMap.action_erase_events(action)
	
	randomize()

func _physics_process(_delta):
	if do_time:
		time += 1

func _input(event) -> void:
	if event.is_action_pressed("Fullscreen"):
		OS.window_fullscreen = ! OS.window_fullscreen
	if event.is_action_pressed("hidden_nauseating_cam_deactivate"):
		Settings.nauseating_camera = false

func get_random_chord(notes_count: int = 3) -> Array:
	var chord: Array = []
	var possible_notes: Array = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "G", "G#"]
	
	
	for i in notes_count:
		var random_note: String = possible_notes[int(rand_range(0, possible_notes.size()))]
		
		# make sure random note isn't already in array
		while chord.find(random_note) != -1:
			random_note = possible_notes[int(rand_range(0, possible_notes.size()))]
		
		chord.append(random_note)
	
	return chord
