extends Node

func _ready() -> void:
	
	# connect buttons to on pressed function
	
	for button in get_tree().get_nodes_in_group("button"):
		if button is BaseButton:
			if button is OptionButton:
				button.connect("pressed", self, "_on_button_down")
				
				var popup: PopupMenu = button.get_popup()
				popup.connect("id_pressed", self, "_on_button_up")
			elif button is CheckBox:
				button.connect("pressed", self, "_on_button_down")
			elif button is Button:
				button.connect("button_down", self, "_on_button_down")
#				button.connect("button_up", self, "_on_button_up")



func _on_stream_finished(stream: AudioStreamPlayer) -> void:
	stream.queue_free()


func play(sound_path: String, stream_data: Dictionary = {}) -> void:
	var p: AudioStreamPlayer = AudioStreamPlayer.new()
	
	p.stream = load(sound_path) as AudioStream
	
	if ! stream_data.empty():
		# set stream data
		
		if "volume_db" in stream_data:
			p. volume_db = stream_data["volume_db"]
		
		if "pitch_scale" in stream_data:
			p.pitch_scale = stream_data["pitch_scale"]
	
	p.connect("finished", self, "_on_stream_finished", [p])
	add_child(p)
	p.play()

func _on_button_down(garbage = null) -> void:
	play("res://assets/sound/button/press1.ogg", {"pitch_scale" : rand_range(0.9, 1.11)})


func _on_button_up(garbage = null) -> void:
	play("res://assets/sound/button/release1.ogg", {"pitch_scale" : rand_range(0.9, 1.11)})
