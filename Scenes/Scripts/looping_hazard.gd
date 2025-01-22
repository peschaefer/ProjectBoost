extends AnimatableBody3D

@onready var endpoint: Marker3D = $Endpoint
@onready var resetpoint: Marker3D = $Resetpoint
@export var duration: float = 1.0
var start_position: Vector3
var reset_location: Vector3
var destination: Vector3
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_SINE

func _ready() -> void:
	destination = endpoint.global_position
	reset_location = resetpoint.global_position
	start_position = global_position
	var tween = create_tween()
	move_obstacle(tween)

func move_obstacle(tween: Tween) -> void:
	#over duration, this tween will move the global position to the destination
	tween.tween_property(self,"global_position",destination, get_duration())
	tween.finished.connect(_on_tween_finished)

func _on_tween_finished():
	global_position = reset_location
	await get_tree().create_timer(0.05).timeout
	var new_tween = create_tween()
	move_obstacle(new_tween)

func get_duration() -> float:
	var total_distance = destination.distance_to(reset_location)
	var current_distance = destination.distance_to(global_position)
	var return_value = (current_distance/total_distance) * duration
	return return_value
