# Not just for settings; this is for everything related to buttons and ui elements.
extends Node

var cam_speed_multiplier: float = 1
var cam_zoom_multiplier: float = 1

var nauseating_camera: bool = false
var bullet_hell: bool = false

func win() -> void:
	Global.do_time = false
	get_tree().change_scene("res://scenes/WinScreen.tscn")

func show_random_chord(label: Label) -> void:
	var chord = Global.get_random_chord(floor(rand_range(3, 7)))
	label.text = str(chord)
