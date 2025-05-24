	shader_type canvas_item;
	uniform float direction: hint_range(-1.0, 1.0, 1.0) = -1.0;
	uniform float frequency: hint_range(0.1, 30.0, 0.1) = 15.0; // more or less dashes
	uniform float speed: hint_range(0.5, 20, 0.5) = 3.0; // rotation speed
	uniform float radius: hint_range(0.01, 1.0, 0.01) = 1.0;
	uniform float line_thickness: hint_range(0.0, 0.5, 0.01) = 0.03;
	uniform vec4 color: source_color = vec4(1.0);
	void fragment() {
	  vec2 pos = UV - vec2(0.5); // center our position
	  float circle = step(length(pos), radius); // create circle within radius 

	  // apply animation wave to circle
	  float angle = atan(pos.y, pos.x);
	  float wave = 0.5 * sin(direction * frequency * angle + TIME * speed) + 0.5;
	  circle *=  wave;
	  //circle *= step(0.5, wave);
	  vec4 circle_outline = vec4(color.rgb, circle);

	  // create mask around edge of texture
	  float rect_alpha = 1.0 - step(abs(pos.x), (0.5-line_thickness)) * step(abs(pos.y), (0.5-line_thickness));

	  // apply circle - but only if it is in the mask area
	  //COLOR =  vec4(COLOR.rgb, rect_alpha);
	  //COLOR =  circle_outline;
	  COLOR =  (circle_outline*rect_alpha) + COLOR;// * vec4(COLOR.rgb, 1.0);
	  //COLOR =  circle_outline * rect_alpha;
	  
	  // apply circle - no maksing
	  //COLOR =  circle_outline * vec4(1.0, 1.0, 1.0, 1.0);
	  // apply circle - demonstrate rect_alpha
	  //COLOR =  circle_outline * vec4(rect_alpha, rect_alpha, rect_alpha, 1.0);
	}