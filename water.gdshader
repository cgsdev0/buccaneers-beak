shader_type spatial;

varying vec3 v_vertex;
global uniform float water_time;
global uniform vec2 water_offset;

uniform sampler2D noise;

void fragment() {
	// float water_time = TIME;
	vec4 n1 = texture(noise, vec2(v_vertex.x / 500.0 + water_time / 50.0, v_vertex.y / 50.0 - water_time / 50.0));
	vec4 n2 = texture(noise, vec2(v_vertex.x / 500.0 - water_time / 30.0, v_vertex.y / 50.0 + water_time / 50.0));
	float n3 =  clamp(n1.r - n2.r, 0.0, 1.0);
	ALBEDO = mix(vec3(0.1, 0.45, 0.92), vec3(0.9, 0.9, 0.9), pow(clamp(v_vertex.y / 4.0, 0.0, 0.8), 3) * n3);
	ALBEDO = mix( ALBEDO,vec3(0.0, 0.12, 0.38), sqrt((4.0 - abs(v_vertex.y)) / 10.0) * 0.8);
	// Place fragment code here.
}

void vertex() {
	// float water_time = TIME;
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float wave1 = sin((world_position.x) / 20.0 + water_time / 2.0) * sin((world_position.z) / 20.0 + water_time / 2.0) * 4.0;
	float wave2 = sin((world_position.x) / 20.0 - water_time / 2.0) * 4.0;
	VERTEX.y = (wave1 + wave2) / 2.0;
	// VERTEX.y = VERTEX.x + VERTEX.z;
	v_vertex.x = world_position.x;
	v_vertex.z = world_position.z;
	v_vertex.y = VERTEX.y;
	vec2 e = vec2(0.01, 0.0);
}