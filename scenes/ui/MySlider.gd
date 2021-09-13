extends BaseUIElement

onready var slider = $HSlider

export var custom_min_value: float = 0.071
export var custom_max_value: float = 0.071

func _ready():
	if custom_min_value != 0.071:
		slider.min_value = custom_min_value
	if custom_max_value != 0.071:
		slider.max_value = custom_max_value

func _on_HSlider_value_changed(value):
	Settings.set(setting, value)
