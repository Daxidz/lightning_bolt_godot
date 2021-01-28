shader_type canvas_item;

uniform float strength: hint_range(0.0, 1000.0);
uniform sampler2D noise;
uniform vec2 texture_size;
uniform float high_threshold: hint_range(0.0, 0.5);
uniform float low_threshold: hint_range(0.0, 0.5);
uniform float beam_width: hint_range(0.0, 1000.0);
uniform float speed: hint_range(0.0, 1000.0);
uniform vec4 base_color: hint_color;

void fragment() {
	vec4 color = base_color;
	float y_alpha;
//	vec4 noise_text = TEXTURE(noise, )
	vec2 pixel_width = texture_size;
	float half_beam_width = beam_width/(2.0*pixel_width.x);
	// To smooth both ends
	if (UV.y < low_threshold+0.02) {
//		color=vec4(1,1,1,1);
//		skip = true;
		y_alpha = UV.y/ low_threshold;
	} else if (UV.y > 1.0-high_threshold-0.02) {
		float m = 1.0 / -high_threshold;
		float b = -m;
		y_alpha = m*UV.y + b;
	} else {
		y_alpha = 1.1;
	}
	
	// Read our noise and make it flow upward with time 
	float noise_value = texture(noise, vec2(UV.x, UV.y+TIME*speed)).r;
	if (UV.x <= 0.5-half_beam_width) {
//		color = vec4(strength, 0.0, 0.0, 2.0*UV.x);
		color *= strength;
		color.a = 2.0*UV.x;
		color.a *= noise_value;
	} else if (UV.x > 0.5+half_beam_width) {
//		color = vec4(strength, 0.0, 0.0, -2.0*UV.x+2.0);
//		color *= strength;
		color.a = -2.0*UV.x+2.0;
		color.a *= noise_value;
	} else {
		color = vec4(strength, 0.0, 0.0, 1.1*noise_value);
	}
		
	color.a = color.a*y_alpha ;
	vec4 sc_color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0);
//	COLOR = add(color, sc_color);
	COLOR = color;
}