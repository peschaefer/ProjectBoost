extends AnimatableBody3D

enum DIRECTION {CLOCKWISE, COUNTER}

@export var duration: float = 1.0
@export var direction: DIRECTION

func _ready() -> void:
	var tween = create_tween()
	tween.set_loops()
	
	var target_rotation: float = 360.0 if direction == DIRECTION.CLOCKWISE else -360.0
	#over duration, this tween will move the global position to the destination
	tween.tween_property(
		self, 
		"rotation_degrees:z", 
		target_rotation, 
		duration
	)
