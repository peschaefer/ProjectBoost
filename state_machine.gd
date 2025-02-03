class_name StateMachine extends Node

var current_state: State
var states: Dictionary = {}

func start_machine(init_states: Array[State]) -> void:
	for state in init_states:
		states[state.get_state_name()] = state
	current_state = init_states[0]
	current_state.enter()
	
func _process(delta: float) -> void:
	current_state.process(delta)

func _physics_process(delta: float) -> void:
	current_state.physics_process(delta)

func transition(target_state: String):
	var new_state = states.get(target_state)
	if new_state == null:
		push_error("An attempt has been made to transition to a non-existent state: %s" % target_state)
		return
	elif current_state.get_state_name() == target_state:
		push_warning("An attempt has been made to transition to the same state: %s" % target_state)
	else:
		current_state.exit()
		current_state = new_state
		current_state.enter()
