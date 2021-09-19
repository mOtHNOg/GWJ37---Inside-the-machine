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

# bloom
var bloom_on_finish = Settings.bloom_amount
const UNBLOOM_SPEED = 1.0
var env: Environment = load("res://default_env.tres")

# music fade out
const MUSIC_FADE_OUT_SPEED = 0.1
onready var music_bus: int = AudioServer.get_bus_index("music")
onready var music_volume: float = AudioServer.get_bus_volume_db(music_bus)

func _ready():
	labels.time.text %= str(stepify(Global.time / 60, 0.1))
	labels.interactions.text %= str(Global.interactions, " / ", Global.total_interactions)
	
	if Global.time != 0:
		labels.score.text %= str(stepify(pow(Global.interactions, 2) / ( pow(Global.time / 60, 0.5)) * 100, 0.1))
	else:
		labels.score.text %= "0"
	
	Settings.apply_bloom = false

func _process(delta):
	env.glow_bloom = lerp(env.glow_bloom, bloom_on_finish * 0.5, UNBLOOM_SPEED * delta)
	
	music_volume = lerp(music_volume, -60, MUSIC_FADE_OUT_SPEED * delta)
	
	AudioServer.set_bus_volume_db(music_bus, music_volume)
	print(AudioServer.get_bus_volume_db(music_bus))

func _on_RestartButton_pressed():
#	Settings.reset()
#	Global.reset()
#	AudioManager.stop()
#
#	get_tree().change_scene("res://scenes/World.tscn")
	
	if restart_click_count <= MAX_RESTART_CLICK_COUNT:
		restart_button.text = restart_button.text.insert(9, "still ")
	restart_click_count += 1

func _on_WinScreen_tree_entered():
	AudioManager.add_button_signals()
