shader_type spatial;

varying vec3 v_vertex;
global uniform float water_time;
global uniform vec2 water_offset;

uniform sampler2D noise;
uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

void fragment() {
	// float water_time = TIME;
	float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;
    vec4 upos = INV_PROJECTION_MATRIX * vec4(SCREEN_UV * 2.0 - 1.0, depth, 1.0);
    vec3 pixel_position = upos.xyz / upos.w;
	
	vec4 n1 = texture(noise, UV + vec2(v_vertex.x / 500.0 + water_time / 80.0, v_vertex.y / 50.0 - water_time / 70.0));
	vec4 n2 = texture(noise, UV + vec2(v_vertex.x / 500.0 - water_time / 50.0, v_vertex.y / 50.0 + water_time / 60.0));
	float n3 =  clamp(n1.r - n2.r, 0.0, 1.0);
	vec4 n4 = texture(noise, vec2(UV.x + sin(water_time / 30.0), UV.y - cos(water_time / 30.0)));
	ALBEDO = mix(vec3(0.1, 0.45, 0.92), vec3(0.9, 0.9, 0.9), round(pow(clamp(v_vertex.y / 2.0, 0.0, 0.8), 3) * n3 * 2.0) / 2.0);
	ALBEDO = mix( ALBEDO,vec3(0.0, 0.12, 0.38), round(sqrt((n4.r + 3.3 - abs(v_vertex.y)) / 5.0) * 0.8 * 2.15) / 10.0 + 0.6);
	// Place fragment code here.
}

void vertex() {
	// float water_time = TIME;
	vec3 world_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float wave1 = sin((world_position.x) / 40.0 + water_time / 3.0) * sin((world_position.z) / 37.0 + water_time / 3.0) * 3.0;
	float wave2 = sin((world_position.x) / 40.0 - water_time / 3.0) * 3.0;
	VERTEX.y = (wave1 + wave2) / 2.0;
	// VERTEX.y = VERTEX.x + VERTEX.z;
	v_vertex.x = world_position.x;
	v_vertex.z = world_position.z;
	v_vertex.y = VERTEX.y;
	
}