extends AnimatableBody3D

@export var destination: Vector3
@export var duration: float = 1.0
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_SINE

func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	tween.set_trans(transition_type)
	#over duration, this tween will move the global position to the destination
	tween.tween_property(self,"global_position",global_position + destination, duration)
	
	tween.tween_property(self, "global_position", global_position, duration)
