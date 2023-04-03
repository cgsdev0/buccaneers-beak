shader_type spatial;


uniform sampler2D roads;
uniform vec3 road_color: source_color;

void fragment() {
	vec3 up = vec3(0.0, 1.0, 0.0);
	vec4 rock = vec4(0.240000, 0.220000, 0.220000, 1.0);
	vec4 sand = vec4(0.800000, 0.712400, 0.216000, 1.0);

	vec4 grass = vec4(0.000000, 0.164706, 0.011765, 1.000000);

	vec3 world_vert = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	float rock_weight = clamp(sqrt(dot(up, (vec4(NORMAL, 1.0) * VIEW_MATRIX).xyz)) - clamp((world_vert.y - 14.0) / 50.0, 0.0, 1.0), 0.0, 1.0);
	float grass_to_sand = sin(world_vert.x / 17.0) * sin(world_vert.z / 20.0) * 2.0 + world_vert.y - 2.0;

	float grass_blend = (sign(grass_to_sand) + 1.0) / 2.0;
	vec3 surface = mix(sand.xyz, grass.xyz, grass_blend);


	if(abs(rock_weight - 0.5) < 0.303)
	{
		ALBEDO = mix(rock.xyz, surface, round(rock_weight * 3.0) / 3.0);
	}
	else if(rock_weight < 0.5)
	{
		ALBEDO = rock.xyz;
	}
	else
	{
		ALBEDO = surface;
	}
	ALBEDO =  mix(ALBEDO, road_color, 1.0 - texture(roads, UV).g);
}
