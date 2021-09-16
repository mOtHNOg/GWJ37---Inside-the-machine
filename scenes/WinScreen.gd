extends Control

onready var labels: Dictionary = {
	"congratulations" : $VBoxContainer/Congratulations,
	"time" : $VBoxContainer/Time,
	"interactions" : $VBoxContainer/Interactions,
	"score" : $VBoxContainer/Score
}

onready var restart_button = $VBoxContainer/CenterContainer/Restart
var restart_click_count: int = 0
const MAX_RESTART_CLICK_COUNT = 10

func _ready():
	labels.time.text %= str(stepify(Global.time / 60, 0.1))
	labels.interactions.text %= str(Global.interactions, " / ", Global.total_interactions)
	
	if Global.time != 0:
		labels.score.text %= str(stepify(pow(Global.interactions, 2) / ( pow(Global.time / 60, 0.5)) * 100, 0.1))
	else:
		labels.score.text %= "0"


func _on_RestartButton_pressed():
#	get_tree().change_scene("res://scenes/World.tscn")
	if restart_click_count <= MAX_RESTART_CLICK_COUNT:
		restart_button.text = restart_button.text.insert(9, "still ")
	restart_click_count += 1

func _on_WinScreen_tree_entered():
	AudioManager.add_button_signals()
