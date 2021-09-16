# Not just for settings; this is for everything related to buttons and ui elements.
extends Node

var cam_speed_multiplier: float = 1
var cam_zoom_multiplier: float = 1

var nauseating_camera: bool = false
var bullet_hell: bool = false

onready var sfx_bus: int = AudioServer.get_bus_index("sfx")
var sfx_volume: float = 1

onready var music_bus: int = AudioServer.get_bus_index("music")
var music_volume: float = 1

func _process(_delta):
	AudioServer.set_bus_volume_db(sfx_bus, ( 1 - sfx_volume ) * -60 )
	print(AudioServer.get_bus_volume_db(sfx_bus))
	AudioServer.set_bus_volume_db(music_bus, ( 1 - music_volume ) * -60 )

func win() -> void:
	Global.do_time = false
	get_tree().change_scene("res://scenes/WinScreen.tscn")

func show_random_chord(label: Label) -> void:
	var chord = Global.get_random_chord(floor(rand_range(3, 7)))
	label.text = str(chord)
