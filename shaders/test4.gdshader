	shader_type canvas_item;
	uniform float speed_phase = 1.0;
	uniform float speed_rotation = 1.0;
	uniform float offset_phase = 0.0;
	uniform float offset_rotation = 0.0; //45
	uniform float frequency = 2.0; // 0.5
	uniform float scale = 1.0; // 0.5
	uniform float contrast = 1.0; // 10
	uniform vec4 color1: source_color = vec4(1.0, 1.0, 1.0, 1.0);
	uniform vec4 color2: source_color = vec4(0.0, 0.0, 0.0, 1.0);
	void fragment() {
			float time_phase = TIME * speed_phase * PI + offset_phase * PI * 2.0 + PI/2.0;
			float time_rotation = TIME * speed_rotation * PI / 4.0 + offset_rotation * PI * 2.0 / 360.0;
			float sinr = sin(time_rotation);
			float cosr = cos(time_rotation);
			
			vec2 uv = (UV - vec2(0.5)) * vec2(2.0) / sqrt(scale);
			uv = vec2(uv.x * cosr - uv.y * sinr, uv.x * sinr + uv.y * cosr);
			
			float val_phase = (sin(uv.x * PI * 2.0 * frequency + time_phase) + 1.0) * 0.5;
			vec4 mycolor = color1 * val_phase + color2 * (1.0-val_phase);
			
			float dist = length(uv);
			//mycolor *= smoothstep(0.0, 1.0, 1.0 - dist);
			mycolor *= 1.0 - dist;
			mycolor.a *= contrast;
			
			//COLOR = vec4(mycolor);
			//COLOR += vec4(mycolor);
			COLOR += mix(COLOR,vec4(mycolor),0.3);
	}