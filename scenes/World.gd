extends Control

export var call_shuffle_positions: bool = false

var boundaries: Dictionary = {
	"top" : -896.0,
	"right" : 2816.0,
	"bottom" : 1440.0,
	"left" : -1728.0}
onready var cam: Camera2D = $ControllableCamera


var juice_started: bool = false # starts music and timer when an input is pressed 


func _ready() -> void:
	if call_shuffle_positions:
		shuffle_positions()

func _process(delta):
	
	if juice_started == false: # when an input is pressed
		for action in InputMap.get_actions():
			if ! action.begins_with("ui"):
				if Input.is_action_just_pressed(action):
					
					AudioManager.play("res://assets/sound/music/squash_soup.ogg", {"volume_db" : -10, "bus" : "music"})
					Global.do_time = true
					
					juice_started = true
					continue
	
	
	if cam.global_position.y < boundaries.top:
		cam.global_position.y = boundaries.bottom
	elif cam.global_position.y > boundaries.bottom:
		cam.global_position.y = boundaries.top
	elif cam.global_position.x > boundaries.right:
		cam.global_position.x = boundaries.left
	elif cam.global_position.x < boundaries.left:
		cam.global_position.x = boundaries.right

func shuffle_positions() -> void:
	var shuffle_node_parents: Array = [$Checkboxes, $Sliders, $Buttons]
	var shuffle_nodes: Array = []
	var shuffle_nodes_pos: Array = []
	
	# add children of ui elemenet groups to new array
	for parent in shuffle_node_parents:
		if parent is Control:
			shuffle_nodes.append_array(parent.get_children())
	
	# put positions of the children into a seperate array
	for node in shuffle_nodes:
		if node is Control:
			shuffle_nodes_pos.append(node.rect_position)
	
	# randomize those positions!
	shuffle_nodes_pos.shuffle()
	
	# apply the randomized positions to the nodes
	for i in shuffle_nodes.size():
		shuffle_nodes[i].rect_position = shuffle_nodes_pos[i]


func _on_World_tree_entered():
	AudioManager.add_button_signals()
