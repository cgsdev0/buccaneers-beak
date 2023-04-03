// Shader Code origin from here: https://www.patreon.com/posts/making-stylized-27402644 by MinionsArt

shader_type sky;
render_mode use_half_res_pass;

// Horizon
uniform float offset_horizon : hint_range(-1.0, 1.0, 0.1) = 0.0;
uniform float horizon_intensity : hint_range(-10.0, 5.0, 0.001) = -3.3;
uniform vec4 horizon_color_day : source_color = vec4(0.0, 0.8, 1.0, 1.0);

// Sun
uniform vec4 sun_color : source_color = vec4(1.0);
uniform float sun_radius : hint_range(0.0, 2.0, 0.001) = 0.5;
uniform bool flat_sun = true;

// Day Background Colors
uniform vec4 day_bottom_color : source_color = vec4(0.4, 1.0, 1.0, 1.0);
uniform vec4 day_top_color : source_color = vec4(0.0, 0.8, 1.0, 1.0);

void sky() {
	// get skyUV to place the sun and the moon
	vec2 skyUV = EYEDIR.xz / EYEDIR.y;
	
	// get the middle -> abs of the EYEDIR to get the horizon
	float horizon = abs((EYEDIR.y * horizon_intensity) - offset_horizon);
	vec3 horizonGlow = clamp((1.0 - horizon * 5.0) * clamp(LIGHT0_DIRECTION.y * 10.0, 0.0, 1.0), 0.0, 1.0) * horizon_color_day.rgb;// 
	
	
	// sun creation
	float sun = distance(EYEDIR.xyz, LIGHT0_DIRECTION);
	float sunDisc = 1.0 - clamp(sun / sun_radius, 0.0, 1.0);
	
	// option to render flat sun
	if (flat_sun == true) {
		sunDisc = roundEven(sunDisc);
	}
	
	// combine sun and moon
	vec3 sunAndMoon = (sunDisc * sun_color.rgb);	
	
	//Sky Background Gradient
	// day color gradient
	vec3 gradientDay = mix(horizon_color_day.rgb, day_top_color.rgb, clamp(EYEDIR.y + horizon_intensity, 0.0, 1.0));
	
	vec3 sky = mix(day_bottom_color.rgb, gradientDay + sunAndMoon, clamp(EYEDIR.y + offset_horizon, 0.0, 1.0));
	
	COLOR = sky;
}