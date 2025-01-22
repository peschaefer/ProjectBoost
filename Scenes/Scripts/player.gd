extends RigidBody3D

#export makes value available in inspector

## How much vertical force is applied when moving.
@export_range(750,2000) var thrust: float = 1000.0
## How much torque is applied when rotating.
@export var torque_thrust: float = 100.0
@export var disabled = false
@export var can_boost = true
#this can be achieved by holding control and dragging the element in from the scene viewer on the left
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles

signal level_completed
signal crashed
signal liftoff

var flying:bool = false

var is_transitioning: bool = false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if disabled:
		return
	if !(Input.is_action_pressed("boost") || Input.is_action_pressed("lean-left") || Input.is_action_pressed("lean-right")):
		rocket_audio.stop()
	if Input.is_action_pressed("boost"):
		signal_takeoff()
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
	#if Input.is_action_just_pressed("uumph"):
		#apply_central_force(basis.y * delta * thrust * 35)
	if Input.is_action_pressed("lean-left"):
		signal_takeoff()
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		right_booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		right_booster_particles.emitting = false
	if Input.is_action_pressed("lean-right"):
		signal_takeoff()
		apply_torque(Vector3(0.0, 0.0, torque_thrust * -delta))
		left_booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		left_booster_particles.emitting = false


func _on_body_entered(body: Node) -> void:
	if is_transitioning == false && disabled == false:
		if "Goal" in body.get_groups():
			complete_level()
		if "Hazard" in body.get_groups():
			crash_sequence()
		
func crash_sequence() -> void:
	if disabled:
		return
	explosion_particles.emitting = true
	explosion_audio.play()
	stop_boosters()
	crashed.emit()
	flying = false
	#is_transitioning = true
	#set_process(false)
	#var tween: Tween = create_tween()
	#tween.tween_interval(2.5)
	#tween.tween_callback(get_tree().reload_current_scene)
	
func complete_level() -> void:
	if disabled:
		return
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
	if flying:
		return
	flying = true
	liftoff.emit()
