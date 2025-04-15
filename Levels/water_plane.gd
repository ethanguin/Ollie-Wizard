extends MeshInstance3D

@onready var shader_mat := $YourMesh.material as ShaderMaterial

func _ready():
	var noise = shader_mat.get_shader_parameter("foam_noise")
	noise.offset += Vector3(1.0, 0.0, 0.0)  # Change offset to scroll the noise
	shader_mat.set_shader_parameter("foam_noise", noise)
