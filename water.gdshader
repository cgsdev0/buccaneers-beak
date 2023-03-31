shader_type spatial;

varying vec3 v_vertex;
uniform float time;
void fragment() {
	
	ALBEDO = mix(vec3(0.1, 0.45, 0.92), vec3(0.9, 0.9, 0.9), pow(clamp(v_vertex.y / 5.0, 0.0, 0.8), 3));
	// Place fragment code here.
}

void vertex() {
	VERTEX.y = sin(VERTEX.x + time / 2.0) * sin(VERTEX.z + time / 2.0) * 5.0;
	v_vertex = VERTEX;
}