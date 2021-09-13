extends BaseUIElement

onready var checkbox := $CheckBox

func _ready():
	if show_warning:
		checkbox.rect_position.y += 16

func _process(_delta) -> void:
	
	# If setting is changed from an external source, button will update
	if Settings.get(setting) != null:
		checkbox.pressed = Settings.get(setting)

func _on_CheckBox_toggled(button_pressed):
	Settings.set(setting, button_pressed)
