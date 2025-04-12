shader_type spatial;
render_mode cull_disabled;

uniform vec4 albedo;

uniform vec3 playerPos = vec3(0.0);
uniform float strength = 0.5;
uniform float radius = 1.0;

void vertex() {
	vec3 world_vert = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz; // model space to world space
	vec3 direction = world_vert - playerPos;
	direction.y = 0.0;
	direction = normalize(direction);
	float dist = distance(playerPos, world_vert);
	float power = smoothstep(radius, 0.0, dist);
	direction = (vec4(direction, 1.0) * MODEL_MATRIX).xyz; // world space direction to model space
	VERTEX += direction * power * strength * (1.0 - UV.y);
}

void fragment() {
	ALBEDO = albedo.rgb;
}