shader_type canvas_item;

uniform vec2 scroll = vec2(0.5, 0.5);
uniform vec2 scroll2 = vec2(0.3, 0.3);
uniform vec2 noiseScale1 = vec2(1, 1);
uniform vec2 noiseScale2 = vec2(1, 1);
uniform sampler2D TONE_MAPPING;
uniform sampler2D NOISE_PATTERN;

void fragment() {
	float tex_alpha = texture(TEXTURE, UV).a;
	float pattern_intensity1 = texture(NOISE_PATTERN, UV * noiseScale1 + TIME * scroll).r;
	float pattern_intensity2 = texture(NOISE_PATTERN, UV * noiseScale2 + TIME * scroll2).r;
	float intensity = tex_alpha * pattern_intensity1 * pattern_intensity2;
	COLOR = texture(TONE_MAPPING, vec2(intensity));
}