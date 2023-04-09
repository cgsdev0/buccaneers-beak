shader_type canvas_item;

uniform vec2 anchor_position;
uniform float peephole = 0.0;
uniform float size = 30.0;

varying vec2 world_pos;

void vertex() {
    world_pos = VERTEX;
}

void fragment() {
	// Place fragment code here.
	if (distance(anchor_position, world_pos) > size * peephole) {
		discard;
	}
}
