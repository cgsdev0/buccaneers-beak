shader_type spatial;
render_mode specular_toon, cull_disabled;

varying vec3 world_position;
varying vec3 v_vertex;
// global uniform float water_time;

uniform sampler2D noise;
const vec3 foam_color = vec3(1.0);
const vec3 water_blue = vec3(0.1, 0.35, 0.92);

global uniform vec3 hole_punch;

void fragment() {
	if (distance(world_position, hole_punch) < 13.0) {
		discard;
	}
	if (distance(world_position, hole_punch) < 13.1) {
		ALBEDO = vec3(1.0);
	}
	else {		
		float water_time = TIME;
		float n = texture(noise, vec2(UV.x + TIME / 7.0, UV.y - TIME)).r;
		float n2 = texture(noise, vec2(UV.x + TIME / 17.0, UV.y / 10.0 - TIME / 10.5)).r;
		float n3 = texture(noise, vec2(UV.x - TIME / 60.0, UV.y  / 10.0)).r;
		float n4 = texture(noise, vec2(UV.x / 1.5, UV.y / 2.0 - TIME / 3.2)).r;
		float n5 = texture(noise, vec2(UV.x / 1.5 + TIME / 20.0, UV.y / 2.0 - TIME / 3.5)).r;
		float edge = round(abs(UV.x - 0.5) * (1.05 + n / 5.0));
		float stripes = clamp((1.0 - round((n2 + n3) / 1.2)), 0.0, 1.0) * 0.2;
		float stripes2 = round((n4 + n5) / 2.0) * 0.1;
		ALBEDO = mix(water_blue, foam_color, clamp(edge + stripes + stripes2, 0.0, 1.0));
	}
}

void vertex() {
	float water_time = TIME;
	world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	VERTEX.x += (texture(noise, VERTEX.xz + vec2(TIME / 19.0)).r - 0.5) * 0.018;
	VERTEX.z += (texture(noise, VERTEX.xz + vec2(TIME / 22.0)).r - 0.5) * 0.015;
	v_vertex = VERTEX;
	
}
void light() {
	float n = texture(noise, v_vertex.xz * 20.0).r;
    DIFFUSE_LIGHT += clamp(
		round(clamp(v_vertex.y / 1.5, 0.0, 1.0) * 2.0) / 1.0 
	  + clamp(round(dot(NORMAL, LIGHT) * (1.2 + n / 2.35)) / 2.0 + 0.35, 0.0, 1.0),
	0.0, 1.0) * ATTENUATION * ALBEDO;
}