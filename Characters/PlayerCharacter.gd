# old code with sin
#extends CharacterBody3D
#const CAMSTOP_X = 500.0
#const CAMSPEED = 5
#const CAMSTOP_Y = CAMSTOP_X
#
#@export_group("Camera")
#@onready var _cam_transform: Node3D = %CamOrigin
#func _process(delta: float) -> void:
	#var horizInput = Input.get_axis("cam_left", "cam_right")
	#var vertInput = Input.get_axis("cam_up", "cam_down")
	#horizInput = remap(horizInput, -1, 1, -CAMSTOP_X, CAMSTOP_X)
	#vertInput = remap(vertInput, -1, 1, -CAMSTOP_X, CAMSTOP_X)
	#var horizPos = horizInput*delta
	#var vertPos = vertInput*delta
	#
	##parabola to slow cam translation. need to rework so it remaps negatives too
	##_cam_transform.position.x = -(1/SCREENSTOP_X)*(.5*horizPos - SCREENSTOP_X)**2 + SCREENSTOP_X
	##sin function to ease the translation on edges
	##_cam_transform.position.x = CAMSTOP_X*sin(horizPos/(2*CAMSTOP_X))
	##_cam_transform.position.z = CAMSTOP_Y*sin(vertPos/(2*CAMSTOP_Y))
	#_cam_transform.position.x = horizPos
	#_cam_transform.position.z = vertPos

# new code with vector math, getting input as a vector. Makes deadspace a circle instead of square-ish
extends CharacterBody3D
const CAMSTOP = 500

@export_group("Camera")
@onready var _cam_transform: Node3D = %CamOrigin
func _process(delta: float) -> void:
	var dirVector = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	
	#parabola to slow cam translation. need to rework so it remaps negatives too
	#_cam_transform.position.x = -(1/SCREENSTOP_X)*(.5*horizPos - SCREENSTOP_X)**2 + SCREENSTOP_X
	#sin function to ease the translation on edges
	#_cam_transform.position.x = CAMSTOP_X*sin(horizPos/(2*CAMSTOP_X))
	#_cam_transform.position.z = CAMSTOP_Y*sin(vertPos/(2*CAMSTOP_Y))
	_cam_transform.position.x = dirVector[0]
	_cam_transform.position.z = dirVector[1]
