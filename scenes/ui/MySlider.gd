extends BaseUIElement

func _on_HSlider_value_changed(value):
	Settings.set(setting, value)
