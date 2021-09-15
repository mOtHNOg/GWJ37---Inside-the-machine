extends Button

export var count_as_interaction: bool = false
export var count_but_not_to_total: bool = false
var interacted: bool = false

export var press_func: String
export var child_as_argument = false

func _ready():
	if count_as_interaction == true:
		Global.total_interactions += 1

func _on_pressed():
	add_to_interactions()
	
	if child_as_argument:
		Settings.call(press_func, get_child(0))
	else:
		Settings.call(press_func)

func add_to_interactions() -> void:
	if ( count_as_interaction or count_but_not_to_total ) and ! interacted:
		interacted = true
		Global.interactions += 1
