shader_type spatial;

varying vec3 v_vertex;
uniform float time;
void fragment() {
	
	ALBEDO = mix(vec3(0.1, 0.45, 0.92), vec3(0.9, 0.9, 0.9), pow(clamp(v_vertex.y / 5.0, 0.0, 0.8), 3));
	// Place fragment code here.
}

void vertex() {
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.y = sin(world_position.x / 40.0 + time / 2.0) * sin(world_position.z / 40.0 + time / 2.0) * 5.0;
	// VERTEX.y = VERTEX.x + VERTEX.z;
	v_vertex = VERTEX;
}