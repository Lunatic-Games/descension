shader_type canvas_item;

uniform float dist_to_screen_border;

const float FULL_TRANSPARENT_DISTANCE = 300.0;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (color.a == 0.0) {
		COLOR = vec4(color.r, color.g, color.b, 0.0);
		return;
	}
	
	if (dist_to_screen_border > FULL_TRANSPARENT_DISTANCE) {
		COLOR = vec4(color.r, color.g, color.b, 0.10);
	} else if (dist_to_screen_border <= 0.0) {
		COLOR = vec4(color.r, color.g, color.b, 1.0);
	} else {
		float a = (dist_to_screen_border / FULL_TRANSPARENT_DISTANCE) * 0.90 + 0.10;
		COLOR = vec4(color.r, color.g, color.b, 1.0 - a);
	}
}