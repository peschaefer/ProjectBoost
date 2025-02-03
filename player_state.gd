class_name PlayerState extends State

var player: PlayerController
var explosion_audio: AudioStreamPlayer
var success_audio: AudioStreamPlayer
var rocket_audio: AudioStreamPlayer3D
var booster_particles: GPUParticles3D
var left_booster_particles: GPUParticles3D
var right_booster_particles: GPUParticles3D
var success_particles: GPUParticles3D
var explosion_particles: GPUParticles3D

func _init(player_controller: PlayerController) -> void:
	player = player_controller
	explosion_audio = player.explosion_audio
	success_audio = player.success_audio
	rocket_audio = player.rocket_audio
	booster_particles = player.booster_particles
	left_booster_particles = player.left_booster_particles
	right_booster_particles = player.right_booster_particles
	success_particles = player.success_particles
	explosion_particles = player.explosion_particles
