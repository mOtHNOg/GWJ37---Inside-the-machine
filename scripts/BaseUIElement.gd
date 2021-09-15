extends Control
class_name BaseUIElement

onready var label: Label = get_node("Label")
onready var warning: Label = get_node_or_null("Warning")

export var count_as_interaction: bool = false
export var count_but_not_to_total: bool = false
var interacted: bool = false

export var label_text: String
export var show_warning: bool = false
export var warning_text: String

export var setting: String

func _ready():
	if count_as_interaction == true:
		Global.total_interactions += 1

func _process(_delta) -> void:
	label.text = label_text
	
	if warning != null:
		warning.visible = show_warning
		warning.text = warning_text

func add_to_interactions() -> void:
	if ( count_as_interaction or count_but_not_to_total ) and ! interacted:
		interacted = true
		Global.interactions += 1
