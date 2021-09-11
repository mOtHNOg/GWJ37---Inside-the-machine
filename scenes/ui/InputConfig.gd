extends Control

onready var actions_dropdown := $ActionsDropdown
onready var action_input_display := $ActionInputDisplay
onready var press_key_indicator := $PressKeyIndicator


onready var raw_action_list: Array = InputMap.get_actions()
var action_list: Array = []
var excluded_action_text: Array = ["ui", "mouse"]

var selected_action: int

var checking_for_inputs: bool = false

func _ready() -> void:
	
	# cleanse action_list of filthy excluded actions
	
	var is_included: bool
	
	for action in raw_action_list:
		
		is_included = true
		
		for i in excluded_action_text:
			if action.begins_with(i):
				is_included = false
				continue
		
		if is_included:
			action_list.append(action)
	
	action_list.sort()
	
	# add input map actions to option button
	for action in action_list:
		
		actions_dropdown.add_item(action)


func _process(delta) -> void:
	selected_action = actions_dropdown.get_selected_id()
	
	action_input_display.text = get_action_input_display_text()
	
	press_key_indicator.visible = checking_for_inputs


func _input(event) -> void:
	
	# sets just pressed input to selected input action
	
	if checking_for_inputs:
		if event is InputEventKey:
			if event.pressed:
				if event.scancode != KEY_ESCAPE:
					
					checking_for_inputs = false
					
					InputMap.action_add_event(action_list[selected_action], event)
					accept_event()
					
				else: # if key press is escape
					
					checking_for_inputs = false


func get_action_input_display_text() -> String:
	
	var selected_action_events_strings: Array = []
	
	# add input events of selected action to array of strings
	for i in InputMap.get_action_list(action_list[selected_action]):
		if i is InputEvent:
			selected_action_events_strings.append(i.as_text())
	
	# change array to string and modify to remove brackets, then return
	return str(selected_action_events_strings).substr(1, str(selected_action_events_strings).length() - 2)


func _on_ClearInput_pressed() -> void:
	
	# delete all inputs of selected action
	InputMap.action_erase_events(action_list[selected_action])

func _on_NewInput_pressed() -> void:
	checking_for_inputs = true
