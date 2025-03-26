extends Node3D
##------------------CAMERA MOVEMENT CODE------------------##
const ELLIPSEWIDTH = 2.5 # Amount to stretch the x-axis so we can move more horizontally
const CAMSTOP = 1  # Max movement range
const SPEED = 4.0  # Speed of camera movement
const RETURN_SPEED = 6.0  # Speed the camera returns to center

@export_group("Camera")
@onready var _cam_transform: Node3D = %CamTransform

var vel := Vector2.ZERO  # Movement speed

func _physics_process(delta: float) -> void:
	var dirVector = Input.get_vector("cam_right", "cam_left", "cam_down", "cam_up")

	if dirVector.length() > 0.01:
		# Move with joystick input
		vel = dirVector * SPEED
	else:
		# Snap back to center when no input
		var center_offset = Vector2(_cam_transform.position.x, _cam_transform.position.z)
		vel = -center_offset.normalized() * RETURN_SPEED * center_offset.length()

	# Apply movement
	var new_x = _cam_transform.position.x + vel.x * delta
	var new_z = _cam_transform.position.z + vel.y * delta

	# Soft boundary using sin-based easing
	_cam_transform.position.x = CAMSTOP * sin(new_x / (CAMSTOP * ELLIPSEWIDTH)) * ELLIPSEWIDTH
	_cam_transform.position.z = CAMSTOP * sin(new_z / CAMSTOP)
##------------------CAMERA MOVEMENT CODE------------------##
