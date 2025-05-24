shader_type canvas_item;
uniform vec3 color1: source_color = vec3(1.0, 1.0, 1.0);
uniform float strength: hint_range(0.0, 1.0) = 0.5;
void fragment() {
	float wave = sin(1.0 + TIME * 1.0);
	vec4 color2 = mix(vec4(color1, COLOR.a), vec4(vec3(wave), COLOR.a), strength);
	
	COLOR = mix(COLOR, vec4(color2.rgb, COLOR.a), strength);
}
