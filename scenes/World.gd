extends Control

export var shuffle_positions: bool = false

func _ready() -> void:
	if shuffle_positions:
		shuffle_positions()

func shuffle_positions() -> void:
	var shuffle_node_parents: Array = [$Checkboxes, $Sliders]
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
		print(shuffle_nodes[i])
		shuffle_nodes[i].rect_position = shuffle_nodes_pos[i]
