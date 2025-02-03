class_name State

func enter() -> void:
	#called when this state is entered
	pass
	
func exit() -> void:
	#called when this state is exited
	pass
	
func process(_delta: float) -> void:
	pass
	
func physics_process(_delta: float) -> void:
	pass
	
func get_state_name() -> String:
	push_error("The 'get_state_name()' method was not overwritten.")
	return ""
