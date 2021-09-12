tool
extends Control

onready var label := $Label
onready var warning := $Warning
onready var checkbox := $CheckBox

export var label_text: String = ""
export var setting: String = ""
export var show_warning: bool = false
export var warning_text: String = "DO NOT PRESS THIS, SERIOUSLY"

func _ready():
	if show_warning:
		checkbox.rect_position.y += 16

func _process(delta):
	label.text = label_text
	
	warning.visible = show_warning
	warning.text = warning_text
	
	# If setting is changed from an external source, button will update
	checkbox.pressed = Settings.get(setting)

func _on_CheckBox_toggled(button_pressed):
	Settings.set(setting, button_pressed)
	print(button_pressed)
