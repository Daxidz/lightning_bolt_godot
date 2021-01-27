shader_type canvas_item;

uniform vec2 mouse_pos;


void fragment() {
	vec4 col;
	
	if ((UV.x < mouse_pos.x + 0.05) && (UV.x > mouse_pos.x - 0.05) 
	|| (UV.y < mouse_pos.y + 0.05) && (UV.y > mouse_pos.y - 0.05)) {
	    col = vec4(1.0, 1.0, 1.0, 1.0);
	} else {
		col = vec4(1.0, 0.0, 0.0, 1.0);
	}

	COLOR = col;
}
