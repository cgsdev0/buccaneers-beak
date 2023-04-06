shader_type canvas_item;

uniform float width = 0.1;
uniform float time = 0.0;
uniform vec4 color: source_color = vec4(1.0);

void fragment() {
	float sweep = -tan(time + PI /2.0) * 2.0;
	vec2 uv = UV;
	uv.x -= sweep;
	COLOR.rgb = color.rgb;
	COLOR.a *= float(int(uv.x - uv.y / 1.2 > 0.0 && uv.x - uv.y / 1.2 < width)) * color.a;
	
}
