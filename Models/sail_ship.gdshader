shader_type spatial;
render_mode unshaded, cull_front;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    ALBEDO = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
}