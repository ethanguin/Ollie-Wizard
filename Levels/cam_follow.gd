extends Node3D

const CAM_SPEED = 5;

func _physics_process(delta: float) -> void:
	position.x = lerpf(position.x, get_parent().get_node("PlayerCharacter").position.x, delta*CAM_SPEED)
	position.z = lerpf(position.z, get_parent().get_node("PlayerCharacter").position.z, delta*CAM_SPEED)
