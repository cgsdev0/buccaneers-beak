shader_type spatial;

void vertex() {
	VERTEX.x += VERTEX.y / 2.0;
}
void fragment() {
	ALBEDO = vec3(UV, 1.0);
	// Place fragment code here.
}
