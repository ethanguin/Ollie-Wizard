extends CharacterBody3D


const SPEED = 3
const JUMP_VELOCITY = 4.5
var lastDir = Vector3.FORWARD
const ROTATION_SPEED = 10


func _physics_process(delta: float) -> void:
	get_parent().get_node("GrassScatter").get_material_override().set_shader_parameter("playerPos", global_transform.origin)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_right", "move_left", "move_back", "move_forward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		lastDir = direction
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	get_node("Ollie").rotation.y = lerp_angle(get_node("Ollie").rotation.y, atan2(lastDir.x, lastDir.z), delta*ROTATION_SPEED)
	

	move_and_slide()
