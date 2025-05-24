	shader_type canvas_item;
	uniform float strength: hint_range(0.0, 1.0) = 0.5;
	uniform float speed: hint_range(0.0, 10.0) = 0.5;
	uniform float angle: hint_range(0.0, 360.0) = 0.;
	void fragment() {
		// get base hue
		//float hue = UV.x * cos(radians(angle)) - UV.y * sin(radians(angle));
		float hue = (UV.x-0.5) * cos(radians(angle)) - (UV.y-0.5) * sin(radians(angle));
		//hue = fract(hue);
		hue = fract(hue + fract(TIME  * speed));
		
		// Hue colors - 1 of 6 bands
		float x = 1.0 - abs(mod(hue / (1.0/ 6.0), 2.0) - 1.0);
		vec3 colors;
		if(hue < 1.0/6.0){
			colors = vec3(1.0, x, 0.0);
		} else if (hue < 1.0/3.0) {
			colors = vec3(x, 1.0, 0.0);
		} else if (hue < 0.5) {
			colors = vec3(0, 1.0, x);
		} else if (hue < 2.0/3.0) {
			colors = vec3(0.0, x, 1.0);
		} else if (hue < 5.0/6.0) {
			colors = vec3(x, 0.0, 1.0);
		} else {
			colors = vec3(1.0, 0.0, x);
		}
		
		// mix original pixel with the appropriate hue color band
		//vec4 color = texture(TEXTURE, UV);
		//color=COLOR;
		//COLOR = mix(color, vec4(colors, color.a), strength);
		COLOR = mix(COLOR, vec4(colors, COLOR.a), strength);

	}