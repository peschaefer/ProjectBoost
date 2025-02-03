class_name PlayerController extends RigidBody3D

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var state_machine: StateMachine = $StateMachine

## How much vertical force is applied when moving.
@export_range(750,2000) var thrust: float = 1000.0
## How much torque is applied when rotating.
@export var torque_thrust: float = 100.0

signal level_completed
signal crashed
signal liftoff

func _ready() -> void:
	var states: Array[State] = [PlayerReadyState.new(self), PlayerDisabledState.new(self), PlayerEnabledState.new(self)]
	state_machine.start_machine(states)

func _on_body_entered(body: Node) -> void:
	if state_machine.current_state.get_state_name() == "PlayerEnabledState":
		if "Goal" in body.get_groups():
			complete_level()
		if "Hazard" in body.get_groups():
			crash_sequence()
		
func crash_sequence() -> void:
	if(state_machine.current_state.get_state_name() != "PlayerEnabledState"):
		return
	explosion_particles.emitting = true
	explosion_audio.play()
	stop_boosters()
	crashed.emit()
	state_machine.transition("PlayerDisabledState")
	
func complete_level() -> void:
	if state_machine.current_state.get_state_name() == "PlayerDisabledState":
		return
	state_machine.transition("PlayerDisabledState")
	success_audio.play()
	stop_boosters()
	success_particles.emitting = true
	#emit level complete and the game can handle what that means
	level_completed.emit()

func stop_boosters():
	rocket_audio.stop()
	booster_particles.emitting = false
	left_booster_particles.emitting = false
	right_booster_particles.emitting = false
	
func signal_takeoff():
	liftoff.emit()
	state_machine.transition("PlayerEnabledState")
	
func reset():
	state_machine.transition("PlayerEnabledState")
