class_name PlayerEnabledState extends PlayerState

static var state_name = "PlayerEnabledState"

func get_state_name() -> String:
	return state_name
	
func process(delta: float) -> void:
	if !(Input.is_action_pressed("boost") || Input.is_action_pressed("lean-left") || Input.is_action_pressed("lean-right")):
		rocket_audio.stop()
	if Input.is_action_pressed("boost"):
		player.apply_central_force(player.basis.y * delta * player.thrust)
		booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
	#if Input.is_action_just_pressed("uumph"):
		#apply_central_force(basis.y * delta * thrust * 35)
	if Input.is_action_pressed("lean-left"):
		player.apply_torque(Vector3(0.0, 0.0, player.torque_thrust * delta))
		right_booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		right_booster_particles.emitting = false
	if Input.is_action_pressed("lean-right"):
		player.apply_torque(Vector3(0.0, 0.0, player.torque_thrust * -delta))
		left_booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		left_booster_particles.emitting = false
