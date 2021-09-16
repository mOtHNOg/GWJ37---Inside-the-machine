extends Control

export var call_shuffle_positions: bool = false

func _ready() -> void:
	if call_shuffle_positions:
		shuffle_positions()
	print(get_node("/root/Settings"))

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
	print("aa")
	AudioManager.add_button_signals()
