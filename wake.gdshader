shader_type spatial;
global uniform float water_time;

varying vec3 v_vertex;
float height(vec2 world_position) {

	float w1 = sin(world_position.x / 10.0 + water_time / 1.0) * sin(world_position.y / 10.0 + water_time / 5.0) * 2.0;
	float w2 = sin(world_position.x / 18.0 - water_time / 20.0) * sin(world_position.y / 10.0 - water_time / 20.0) * 2.0;
	return (w1 + w2) / 2.0;
}
void vertex() {
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.y = height(world_position.xz) - world_position.y - 2.98;
	v_vertex = VERTEX;
}

void fragment() {
	ALBEDO = COLOR.xyz;
	ALPHA = COLOR.a;
}

void light() {
    DIFFUSE_LIGHT += clamp(
		round(clamp(v_vertex.y / 1.5, 0.0, 1.0) * 2.0) / 1.0 
	  + clamp(round(dot(NORMAL, LIGHT)) / 2.0 + 0.35, 0.0, 1.0),
	0.0, 1.0) * ATTENUATION * ALBEDO;
}
