tool
extends Control

onready var label := $Label

export var label_text: String = ""
export var setting: String = ""

func _process(delta):
	label.text = label_text

func _on_CheckBox_toggled(button_pressed):
	Settings.set(setting, button_pressed)
	print(button_pressed)
