extends Control
class_name BaseUIElement

onready var label: Label = get_node("Label")
onready var warning: Label = get_node_or_null("Warning")

export var label_text: String
export var show_warning: bool = false
export var warning_text: String

export var setting: String

func _process(_delta) -> void:
	label.text = label_text
	
	if warning != null:
		warning.visible = show_warning
		warning.text = warning_text
	
