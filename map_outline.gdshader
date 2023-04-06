shader_type canvas_item;

uniform vec4 color : source_color = vec4(1.0);
uniform vec4 color2 :source_color = vec4(1.0);
uniform float width : hint_range(0, 10) = 1.0;

bool hasContraryNeighbour(vec2 uv, vec2 texture_pixel_size, sampler2D texture) {
	int result = 0;
	for (float i = -ceil(width); i <= ceil(width); i++) {
		float x = abs(i) > width ? width * sign(i) : i;
		float offset;
		
		offset = width - abs(x);

		for (float j = -ceil(offset); j <= ceil(offset); j++) {
			float y = abs(j) > offset ? offset * sign(j) : j;
			vec2 xy = uv + texture_pixel_size * vec2(x, y);
			
			result |= int((xy != clamp(xy, vec2(0.0), vec2(1.0)) || texture(texture, xy).a == 0.0));
		}
	}
	
	return bool(result);
}

void fragment() {
	vec2 uv = UV;
	
	if ((COLOR.a > 0.0) && hasContraryNeighbour(uv, TEXTURE_PIXEL_SIZE, TEXTURE)) {
		COLOR = color;
	}
	else {
		COLOR = color2;
		COLOR.a = texture(TEXTURE, uv).a * color2.a;
	}
}