class_name PlayerReadyState extends PlayerState

static var state_name = "PlayerReadyState"

func get_state_name() -> String:
	return state_name
	
func process(_delta):
	if Input.is_action_just_pressed("boost") || Input.is_action_just_pressed("lean-left") || Input.is_action_just_pressed("lean-right"):
		signal_takeoff()

func signal_takeoff():
	player.signal_takeoff()
