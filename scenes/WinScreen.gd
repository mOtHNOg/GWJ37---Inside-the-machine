extends Control

onready var labels: Dictionary = {
	"congratulations" : $Labels/Congratulations,
	"time" : $Labels/Time,
	"interactions" : $Labels/Interactions,
	"score" : $Labels/Score
}

func _ready():
	labels.time.text %= str(stepify(Global.time / 60, 0.1))
	labels.interactions.text %= str(Global.interactions, " / ", Global.total_interactions)
	labels.score.text %= str(stepify(pow(Global.interactions, 2) / ( Global.time / 60 ) * 1000, 0.1))
