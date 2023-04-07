shader_type spatial;
render_mode specular_toon;

varying vec3 v_vertex;
global uniform float water_time;
global uniform vec2 water_offset;

uniform sampler2D noise;
uniform sampler2D depth_texture : hint_depth_texture, filter_nearest;

const float beer_factor = 0.35;
const float foam_max_distance = 0.25;
const float foam_min_distance = 0.04;
const vec4 foam_color = vec4(1.0);
varying vec3 viewNormal;


void fragment() {
//	float water_time = TIME;
	float depthVal = texture(depth_texture, SCREEN_UV).r;
	float depth = PROJECTION_MATRIX[3][2] / (depthVal + PROJECTION_MATRIX[2][2]);
	depth = depth + VERTEX.z;
	depth = exp(-depth * beer_factor);
	depth = 1.0 - depth;
	vec4 view_pos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depthVal, 1.0);
    view_pos /= view_pos.w;
    vec3 existingNormal = normalize(cross( dFdx(view_pos.xyz), dFdy(view_pos.xyz)));
	float normalDot = clamp(dot(existingNormal.xyz, viewNormal), 0.0, 1.0);
	float foamDistance = mix(foam_max_distance, foam_min_distance, normalDot);
	
	float foamDepth = clamp(depth / foamDistance, 0.0, 1.0);
	
	vec2 water_offset2 = -water_offset / 200.0;
	
	vec4 n1 = texture(noise, mod(UV - water_offset2, 1.0) + vec2(v_vertex.x / 500.0 + water_time / 80.0, v_vertex.y / 50.0 - water_time / 70.0));
	vec4 n2 = texture(noise, mod(UV - water_offset2, 1.0) + vec2(v_vertex.x / 500.0 - water_time / 50.0, v_vertex.y / 50.0 + water_time / 60.0));
	float n3 =  clamp(n1.r - n2.r, 0.0, 1.0);
	ALBEDO = mix(vec3(0.1, 0.35, 0.92), foam_color.rgb, round(pow(clamp(v_vertex.y / 1.5, 0.0, 0.8), 3) * n3 * 2.0) / 2.0);
//	ALBEDO = mix( ALBEDO,vec3(0.0, 0.12, 0.38), round(sqrt((n4.r + 3.3 - abs(v_vertex.y)) / 5.0) * 0.8 * 2.15) / 10.0 + 0.6);
	// Place fragment code here.
	ALBEDO = mix(ALBEDO, foam_color.rgb, round(1.0 - foamDepth));
	ROUGHNESS = 1.0;
}

float height(vec2 world_position) {
//	float water_time = TIME;
	float w1 = sin(world_position.x / 10.0 + water_time / 1.0) * sin(world_position.y / 10.0 + water_time / 5.0) * 2.0;
	float w2 = sin(world_position.x / 18.0 - water_time / 20.0) * sin(world_position.y / 10.0 - water_time / 20.0) * 2.0;
	return (w1 + w2) / 2.0;
}


void vertex() {
//	float water_time = TIME;
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
//	float wave1 = sin((world_position.x) / 40.0 + water_time / 3.0) * sin((world_position.z) / 37.0 + water_time / 3.0) * 2.0;
//	float wave2 = sin((world_position.x) / 40.0 - water_time / 2.4) * 2.0;
//	v_vertex.x = world_position.x;
//	v_vertex.z = world_position.z;
//	v_vertex.y = (wave1 + wave2) / 2.0;
	
	VERTEX.y = height(world_position.xz);
	v_vertex.y = VERTEX.y;
	vec2 e = vec2(0.1, 0.0);
	vec3 normal = normalize(
		vec3(height(world_position.xz - e) - height(world_position.xz + e), 
		e.x, height(world_position.xz - e.yx) - height(world_position.xz + e.yx)));
	NORMAL = normal;
	viewNormal = (MODELVIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
}
void light() {
	float n = texture(noise, v_vertex.xz * 20.0).r;
    DIFFUSE_LIGHT += clamp(
		round(clamp(v_vertex.y / 1.5, 0.0, 1.0) * 2.0) / 1.0 
	  + clamp(round(dot(NORMAL, LIGHT) * (1.2 + n / 2.35)) / 2.0 + 0.35, 0.0, 1.0),
	0.0, 1.0) * ATTENUATION * ALBEDO;
}