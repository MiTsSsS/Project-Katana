shader_type canvas_item;

uniform bool active = false;

void fragment() {
	if(active && COLOR != vec4(0.0, 0.0, 0.0, 0.0)) {
		COLOR = vec4(1.0, 1.0, 1.0, 1.0);
	}
}
