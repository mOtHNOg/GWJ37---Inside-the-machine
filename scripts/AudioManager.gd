extends Node

onready var world := get_node("/root/World")

var num_players: int = 8
var bus: String = "master"

var available: Array = []
var queue: Array = []


func _ready() -> void:
	# add audio stream players
	
	for i in num_players:
		var p: AudioStreamPlayer = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
	
	
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
				button.connect("button_up", self, "_on_button_up")



func _on_stream_finished(stream: AudioStreamPlayer) -> void:
	# add audio stream to available
	
	available.append(stream)


func play(sound_path: String) -> void:
	queue.append(sound_path)


func _process(_delta) -> void:
	# play sound with available audio stream if sound is in queue
	
	if ! queue.empty() and ! available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].pitch_scale = rand_range(0.9, 1.11)
		available[0].play()
		available.remove(0)


func _on_button_down(garbage = null) -> void:
	play("res://assets/sound/button/press1.ogg")


func _on_button_up(garbage = null) -> void:
	play("res://assets/sound/button/release1.ogg")
