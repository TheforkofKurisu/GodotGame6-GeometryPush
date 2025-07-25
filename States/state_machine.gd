extends Node

@export var initial_state:State 

var states:Dictionary = {}
var current_state:State
var host

func _ready() -> void:
	host = get_parent()
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_child_transition)
			
	if initial_state:
		initial_state.enter(host)
		current_state = initial_state
	
			
func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func on_child_transition(state,new_state_name):
	if state != current_state:
		print("state is not current_state!")
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		print("new state is not exist!")
		return
		
	if current_state:
		current_state.exit()
	
	new_state.enter(host)
	current_state = new_state	
